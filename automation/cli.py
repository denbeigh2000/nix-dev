#!/usr/bin/env python3

import subprocess
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple

import click
import requests
from click import ClickException
from dateutil import parser
from dateutil.tz import UTC
from requests import RequestException

ROOT = Path(__file__).parent.parent
NIXPKGS_FILE = ROOT / "nixpkgs/default.nix"
RUST_OVERLAY_FILE = ROOT / "rust_overlay/default.nix"

DEFAULT_RUST_OVERLAY_REF = "master"

DEFAULT_CHANNEL = "nixpkgs-unstable"
CHANNELS = [
    DEFAULT_CHANNEL,
    "21.11",
]

GITHUB_COMMIT_INFO_URL_TEMPLATE = (
    "https://api.github.com/repos/{owner}/{name}/commits/{ref}"
)
GITHUB_COMMIT_TARBALL_URL_TEMPLATE = (
    "https://github.com/{owner}/{name}/archive/{sha}.tar.gz"
)

TARBALL_TEMPLATE = r"""import (builtins.fetchTarball {{
  # Descriptive name to make the store path easier to identify
  name = "{name}";
  url = "{url}";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "{sha}";
}})
"""

FETCH_NIXDEV_TEMPLATE = """pkgs.fetchFromGitHub {{
  owner = "denbeigh2000";
  repo = "nix-dev";
  # Latest master as of {date_str}
  rev = "{sha}";
  sha256 = "{checksum}";
}}"""


def _run_git_cmd(args: List[str]) -> str:
    argv = ["git"] + args
    proc = subprocess.run(argv, capture_output=True)
    try:
        proc.check_returncode()
    except subprocess.SubprocessError:
        print(proc.stderr.decode("utf-8"))
        raise

    return proc.stdout.decode("utf-8").strip()


def check_master_branch() -> None:
    branch = _run_git_cmd(["rev-parse", "--abbrev-ref", "HEAD"])
    if branch != "master":
        raise ClickException(f"we are on non-master branch {branch}")

    _run_git_cmd(["fetch", "origin", "master"])
    local_head = _run_git_cmd(["rev-parse", "HEAD"])
    remote_head = _run_git_cmd(["rev-parse", "origin/master"])
    if local_head != remote_head:
        raise ClickException("we have fallen behind the master branch, retry")


def has_changes() -> bool:
    output = _run_git_cmd(["status", "--porcelain"])

    if output == "M pkgs.nix":
        return True
    elif output == "":
        return False
    else:
        raise ClickException("Unexpected git state changes, refusing to commit")


def find_pkgs_nix() -> str:
    proc = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True)
    proc.check_returncode()

    path = proc.stdout.decode("utf-8").strip()

    return f"{path}/pkgs.nix"


def get_commit_info(repo_owner: str, repo_name: str, ref: str) -> Tuple[str, datetime]:
    url = GITHUB_COMMIT_INFO_URL_TEMPLATE.format(
        owner=repo_owner, name=repo_name, ref=ref
    )

    try:
        resp = requests.get(url)
    except RequestException as e:
        raise ClickException(f"Error getting commit info: {e}")

    data = resp.json()
    sha = data.get("sha")
    if sha is None:
        print(data)
        raise ClickException("received no sha from github")

    date = data.get("commit", {}).get("committer", {}).get("date")
    if date is None:
        print(data)
        raise ClickException("received no commit date from github")

    date = parser.parse(date).astimezone(UTC)

    return (sha, date)


def update_github_tarball(
    package_name: str, repo_owner: str, repo_name: str, ref: str, output_file: Path
) -> None:
    (sha, date) = get_commit_info(repo_owner, repo_name, ref)
    tarball_url = GITHUB_COMMIT_TARBALL_URL_TEMPLATE.format(
        owner=repo_owner, name=repo_name, sha=sha
    )
    checksum = get_url_shasum(tarball_url)

    date_str = date.strftime("%Y-%m-%d")
    name = f"{package_name}-{date_str}"
    out_data = TARBALL_TEMPLATE.format(name=name, url=tarball_url, sha=checksum)
    maybe_write_file(output_file, out_data)


def get_commit_shasum(repo_owner: str, repo_name: str, sha: str) -> str:
    url = GITHUB_COMMIT_TARBALL_URL_TEMPLATE.format(
        owner=repo_owner, name=repo_name, sha=sha
    )
    return get_url_shasum(url)


def get_url_shasum(tarball_url: str) -> str:
    proc = subprocess.run(
        ["nix-prefetch-url", "--unpack", tarball_url], capture_output=True
    )
    code = proc.returncode
    if code != 0:
        stderr = proc.stderr.decode("utf-8")
        raise ClickException(
            f"nix-prefetch-url exited with non-success code {code}\n\n{stderr}"
        )

    return proc.stdout.decode("utf-8").strip()


def maybe_write_file(path: Path, data: str) -> None:
    if path.exists() and path.read_text() == data:
        name = path.relative_to(ROOT)
        print(f"{name} up to date")
        return

    path.write_text(data)


@click.group(name="cli")
def cli() -> None:
    pass


@cli.command(name="autocheck")
@click.argument("channel", default=DEFAULT_CHANNEL, type=click.Choice(CHANNELS))
@click.pass_context
def autocheck(ctx: click.Context, channel: str) -> None:
    ctx.invoke(upgrade)
    ctx.invoke(push)


@cli.command(name="push")
def push() -> None:
    if not has_changes():
        print("No changes to commit")
        return

    check_master_branch()

    pkgs_path = find_pkgs_nix()
    time_now = datetime.now(UTC)

    time_str = time_now.strftime("%Y-%m-%d")
    commit_msg = f"bot: updated nixpkgs on {time_str}"

    subprocess.run(["git", "add", pkgs_path]).check_returncode()
    subprocess.run(["git", "commit", "-m", commit_msg]).check_returncode()
    subprocess.run(["git", "push", "origin", "master"]).check_returncode()


@cli.command(name="get-latest")
def get_latest() -> None:
    (sha, date) = get_commit_info("denbeigh2000", "nix-dev", "master")
    checksum = get_commit_shasum("denbeigh2000", "nix-dev", sha)
    date_str = date.strftime("%Y-%m-%d")
    msg = FETCH_NIXDEV_TEMPLATE.format(date_str=date_str, sha=sha, checksum=checksum)
    print(msg, end="")


@cli.group(name="upgrade", invoke_without_command=True)
@click.pass_context
def upgrade(ctx: click.Context) -> None:
    pass
    # ctx.invoke(upgrade_nixpkgs, output_file=NIXPKGS_FILE, channel=DEFAULT_CHANNEL)
    # ctx.invoke(
    #     upgrade_rust_overlay,
    #     output_file=RUST_OVERLAY_FILE,
    #     ref=DEFAULT_RUST_OVERLAY_REF,
    # )


@upgrade.command(name="nixpkgs")
@click.option("--output-file", type=Path, default=NIXPKGS_FILE)
@click.option("--commit")
@click.argument("channel", default=DEFAULT_CHANNEL, type=click.Choice(CHANNELS))
def upgrade_nixpkgs(output_file: Path, commit: Optional[str], channel: str) -> None:
    if commit is None:
        ref = channel
        pkg_title = channel
    else:
        ref = commit
        pkg_title = "commit"

    update_github_tarball(pkg_title, "nixos", "nixpkgs", ref, output_file)


@upgrade.command(name="rust-overlay")
@click.option("--output-file", type=Path, default=RUST_OVERLAY_FILE)
@click.argument("ref", default=DEFAULT_RUST_OVERLAY_REF)
def upgrade_rust_overlay(output_file: Path, ref: str) -> None:
    update_github_tarball("rust-overlay", "oxalica", "rust-overlay", ref, output_file)


if __name__ == "__main__":
    cli()
