"""Task module for the installer"""

import os
import datetime
import requests
from invoke import task


@task
def build(ctx):
    """
    Build the Flutter application
    """
    ctx.run("echo 'Building APK files of the app...'")
    ctx.run("flutter pub get")
    ctx.run("flutter build apk --split-per-abi")
    # This command results in three APK files:
    # raspirri_app/build/app/outputs/apk/release/app-armeabi-v7a-release.apk
    # raspirri_app/build/app/outputs/apk/release/app-arm64-v8a-release.apk
    # raspirri_app/build/app/outputs/apk/release/app-x86_64-release.apk


@task
def clean(ctx):
    """
    Clean build artifacts
    """
    ctx.run("flutter clean")


def upload_local_files(
    github_token: str,
    release_id: str,
    organization: str,
    repository_name: str,
    filename: str,
    installer_file: str,
) -> None:
    # Upload the installer file
    upload_url = (
        f"https://uploads.github.com/repos/{organization}"
        + f"/{repository_name}/releases/{release_id}/assets?"
        + f"{filename}"
    )

    with open(installer_file, "rb") as file_content:
        upload_response = requests.post(
            upload_url,
            headers={
                "Authorization": f"Bearer {github_token}",
                "Accept": "application/vnd.github+json",
                "Content-Type": "application/octet-stream",
            },
            data=file_content,
        )
        if upload_response.status_code == 201:
            print(f"Installer {installer_file} uploaded successfully")
        else:
            print(
                f"Failed to upload installer: {installer_file}: {upload_response} to: {upload_url}"
            )


@task(pre=[clean, build])
def upload_to_github(ctx):
    """
    Upload the installer to GitHub Releases
    """
    ctx.run("echo 'Uploading release tarball to release assets...'")
    organization = "gardenifi"
    repository_name = "raspirri_app"
    github_token = os.environ.get("GITHUB_ACCESS_TOKEN", None)
    version = os.environ.get("NEW_VERSION", None)

    # GitHub API endpoint to create a release
    release_url = (
        f"https://api.github.com/repos/{organization}/{repository_name}/releases"
    )

    today_date = datetime.datetime.now().strftime("%Y-%m-%d")
    # Remove dots from the version
    version_numbers = version.replace(".", "")
    # Concatenate the components
    release_description = (
        f'<a href="https://github.com/gardenifi/raspirri_app/blob/main/CHANGELOG.md#v{version_numbers}---{today_date}">'
        "Release Description</a>"
    )

    # Create a release
    response = requests.post(
        release_url,
        headers={"Authorization": f"token {github_token}"},
        json={
            "tag_name": f"v{version}",  # Tag for the release
            "name": f"Release v{version}",  # Name of the release
            "body": f"{release_description}",  # Description of the release
        },
    )

    if response.status_code == 201:

        # Path to the generated installer files
        installer_file_1 = f"build/app/outputs/apk/release/app-armeabi-v7a-release.apk"
        filename1 = os.path.basename(installer_file_1)
        installer_file_2 = f"build/app/outputs/apk/release/app-arm64-v8a-release.apk"
        filename2 = os.path.basename(installer_file_2)
        installer_file_3 = f"build/app/outputs/apk/release/app-x86_64-release.apk"
        filename3 = os.path.basename(installer_file_3)

        print(f"Release v{version} created successfully")
        release_id = response.json()["id"]
        upload_local_files(
            github_token,
            release_id,
            organization,
            repository_name,
            filename1,
            installer_file_1,
        )
        upload_local_files(
            github_token,
            release_id,
            organization,
            repository_name,
            filename2,
            installer_file_2,
        )
        upload_local_files(
            github_token,
            release_id,
            organization,
            repository_name,
            filename3,
            installer_file_3,
        )
    else:
        print(f"Failed to create release v{version}: Response: {response}")
