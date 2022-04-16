#!/usr/bin/env python3

import subprocess
from datetime import datetime
from pathlib import Path
from typing import List, Optional

import click
import requests
from click import ClickException
from dateutil import parser
from dateutil.tz import UTC
from requests import RequestException

DEFAULT_CHANNEL = "nixpkgs-unstable"
CHANNELS = [
    DEFAULT_CHANNEL,
    "21.11",
]

NIXPKGS_COMMIT_INFO_URL_TEMPLATE = (
    "https://api.github.com/repos/nixos/nixpkgs/commits/{facet}"
)
NIXPKGS_COMMIT_TARBALL_URL_TEMPLATE = (
    "https://github.com/nixos/nixpkgs/archive/{sha}.tar.gz"
)

PKGS_NIX_TEMPLATE = r"""
{{ system ? builtins.currentSystem }}:

import (builtins.fetchTarball {{
  # Descriptive name to make the store path easier to identify
  name = "{channel}-{date}";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "{url}";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "{checksum_sha}";
}}) {{ system = system; }}
"""


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


def get_commit_info(facet: str) -> (str, str):
    url = NIXPKGS_COMMIT_INFO_URL_TEMPLATE.format(facet=facet)

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


@click.group(name="cli")
def cli() -> None:
    pass


@cli.command(name="autocheck")
@click.argument("channel", default=DEFAULT_CHANNEL, type=click.Choice(CHANNELS))
@click.pass_context
def autocheck(ctx: click.Context, channel: str) -> None:
    ctx.invoke(upgrade, output_file=None, commit=None, channel=channel)
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


@cli.command(name="upgrade")
@click.option("--output-file")
@click.option("--commit")
@click.argument("channel", default=DEFAULT_CHANNEL, type=click.Choice(CHANNELS))
def upgrade(output_file: Optional[str], commit: Optional[str], channel: str) -> None:
    (sha, date) = get_commit_info(commit or channel)

    if output_file is None:
        output_file = find_pkgs_nix()

    output_file = Path(output_file)
    tarball_url = NIXPKGS_COMMIT_TARBALL_URL_TEMPLATE.format(sha=sha)
    proc = subprocess.run(
        ["nix-prefetch-url", "--unpack", tarball_url], capture_output=True
    )
    code = proc.returncode
    if code != 0:
        stderr = proc.stderr.decode("utf-8")
        raise ClickException(
            f"nix-prefetch-url exited with non-success code {code}\n\n{stderr}"
        )

    checksum = proc.stdout.decode("utf-8").strip()

    date_str = date.strftime("%Y-%m-%d")
    out_data = PKGS_NIX_TEMPLATE.format(
        channel=channel, date=date_str, url=tarball_url, checksum_sha=checksum
    )

    if output_file.exists() and output_file.read_text() == out_data:
        print("Aborting: content identical")

    output_file.write_text(out_data)


if __name__ == "__main__":
    cli()
