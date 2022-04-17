#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name="automation-cli",
    version="0.1",
    # Modules to import from other scripts:
    packages=find_packages(),
    # Executables
    entry_points={
        "console_scripts": [
            "cli=automation_cli.cli:cli",
        ],
    },
)
