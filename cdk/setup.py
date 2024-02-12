#!/usr/bin/env python
from os import path

from setuptools import find_packages, setup

here = path.abspath(path.dirname(__file__))

setup(
    name='service-cdk',
    version='3.1',
    classifiers=[
        'Topic :: Software Development :: Build Tools',
        'Programming Language :: Python :: 10',
    ],
    url='https://github.com/kyiminkhant11/serverless-text-to-speech.git',
    packages=find_packages(exclude=['contrib', 'docs', 'tests']),
    package_data={'': ['*.json']},
    include_package_data=True,
    python_requires='>=3.11',
    install_requires=[],
)
