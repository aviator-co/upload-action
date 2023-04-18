# Github Action to upload test artifacts to Aviator

Aviator is a developer productivity platform that helps keep builds stable at scale. This GitHub action is an extension to the Aviator service that uploads test artifacts to the Aviator server. Aviator analyzes and catalogs these test artifacts to perform the following functions:

- Identify flaky tests in the system reactively and proactively. Aviator provides APIs and webhooks to report these results.
- Historical view of a particular test case - how often has the test failed (flaky or not), and has the test become stable / unstable. Views by feature branches vs. base branches.
- Provides visibility into whether test stability is degrading or improving for base branches.
- Whether test run times are increasing or decreasing (understand P50, P90 , etc of test run times).
- Ability to rerun the test suite at a particular cadence (nightly jobs) to proactively identify flakes.
- Provides visibility into whether the test suite is failing because of infra issues (something where we don’t even get a test report) or a real test failure.
- Automatically rerun the test suite if the test failed because of infra issues.
- Ability to rerun flaky tests so users can get clean test results.

Read more in our docs: https://docs.aviator.co/

## Usage
To use the Github Action, you can add an additional step using this action. You'll need to
- Specify the path to the `assets`. 
- Set the `aviator_api_token`. You can add this as a [secret in your repository](https://docs.github.com/en/actions/security-guides/encrypted-secrets).
- Add the `if: success() || failure()` conditional statement. This will ensure that the files are uploaded regardless of test failure.

```
name: Run tests and upload results

on: [push]

jobs:
  test-and-upload:
    name: Test and Upload
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3
    - name: Set up Python 3.7
      uses: actions/setup-python@v1
      with:
        python-version: 3.7
    - name: Install dependencies and run test
      run: |
        pip install pytest
        python -m pytest -vv --junitxml="test_results/output.xml"
    - name: Upload files with github action
      uses: aviator-co/upload-action@v0
      if: success() || failure()
      with:
        assets: test_results/output.xml
        aviator_api_token: ${{ secrets.AVIATOR_API_TOKEN }}
```

---

## Resources

[GitHub Action Documentation](https://docs.github.com/en/actions) - Docs for using, creating, and sharing GitHub Actions.

### How to Contribute

We welcome [issues](https://github.com/aviator-co/upload-action/issues) to and [pull requests](https://github.com/aviator-co/upload-action/pulls) against this repository!

