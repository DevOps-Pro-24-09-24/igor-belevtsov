# Project Code Linting and YAML Validation Setup

This project uses **`flake8`** to lint Python code (specifically checking for trailing whitespaces) and **`yamllint`** to ensure proper formatting of YAML files. These checks are automated using **`pre-commit`** hooks, so you don’t have to worry about manually running them every time you commit code.

## Setup Instructions

### 1. Clone the Repository

First, clone the repository to your local machine:

   ```bash
   git clone https://github.com/DevOps-Pro-24-09-24/igor-belevtsov.git
   cd igor-belevtsov
   ```

### 2. Install Dependencies

We use Python's `pip3` (or `Poetry`) to manage dependencies. All the required tools (`pre-commit`) are listed in the `requirements.txt` file.

#### If Using `pip3`:

   ```bash
   pip3 install -r requirements.txt
   ```

#### If Using Poetry:

   ```bash
   poetry install
   ```

This will install all the necessary packages.

### 3. Install Pre-commit Hooks

After installing the dependencies, you need to set up the Git pre-commit hooks that automatically run `flake8` and `yamllint` before every commit.

To do that, run:

   ```bash
   pre-commit install
   ```

This command will install the hooks and ensure they run automatically before every commit.

### 4. Pre-commit Hook Configuration

The hook configuration is defined in a `.pre-commit-config.yaml` file located in the root of the repository. This file ensures that `flake8` checks for trailing whitespace in Python files and `yamllint` validates all YAML files.

Here’s the content of the `.pre-commit-config.yaml`:

   ```
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
-   repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
    -   id: black
   ```

- **`flake8`** is used to check for trailing whitespaces.
- **`yamllint`** will run on all `.yml` and `.yaml` files and ensure proper formatting.

### 5. Running Pre-commit Manually (Optional)

If you want to run the pre-commit checks manually (without making a commit), you can do so with:

   ```bash
   pre-commit run --all-files
   ```

This will run the linter checks across all Python and YAML files in the repository.

## Usage Guide

Once you have the pre-commit hooks installed, the process becomes automatic. Here’s how it works:

### Committing Code

1. Make changes to your Python or YAML files.
2. Stage your changes using `git add`:

   ```bash
   git add <your files>
   ```

3. Commit your changes:

   ```bash
   git commit -m "Your commit message"
   ```

When you run `git commit`, the pre-commit hooks will automatically execute:

- **`flake8`** will check all Python files for trailing whitespaces.
- **`yamllint`** will ensure your YAML files are correctly formatted.

If any issues are detected, the commit will be blocked, and you’ll be shown details about what needs to be fixed.

### Fixing Linting Issues

If the pre-commit hook catches any issues:

- For Python files, remove any trailing whitespaces where indicated.
- For YAML files, follow the output to fix formatting issues.

After fixing the issues, you can re-add the files (`git add <file>`) and try committing again.

### Troubleshooting

#### Pre-commit Fails to Run

If you encounter issues with the pre-commit hook not running:

1. Ensure that `pre-commit` is installed by running:

   ```bash
   pre-commit --version
   ```

2. Verify that the hooks are installed by running:

   ```bash
   pre-commit install
   ```

#### Python or YAML Files Are Failing the Checks

If your commit is blocked due to linting errors, carefully read the output provided by `flake8` and `yamllint` to understand what needs to be corrected. Most common issues include trailing whitespaces in Python files or incorrect indentation in YAML files.

### 6. Contributing

When contributing to this repository, please ensure that:

- Your Python code does not contain trailing whitespaces.
- Your YAML files are properly formatted and valid.

These checks will be enforced automatically before any commits are accepted.

### 7. Optional: Updating Pre-commit Configuration

If the linting rules need to be adjusted (e.g., to add more flake8 rules or modify YAML formatting), you can update the `.pre-commit-config.yaml` file. After making changes, run:

   ```bash
   pre-commit autoupdate
   ```

This will pull the latest versions of the hooks and update them accordingly.

---

## Summary

This setup will ensure that:

- **Python files** are checked for trailing whitespaces using `flake8`.
- **YAML files** are validated for proper formatting using `yamllint`.
- All checks are enforced automatically before every commit, ensuring consistency and quality across the project.

By following these steps, you’ll ensure that all contributors have a consistent development environment and that no code with linting or formatting issues is committed to the repository.

---

# Commit Message Pattern Validation Setup

This project enforces a specific commit message pattern to ensure that all commits follow a standardized format. The commit message must follow the pattern **`Add: |Created: |Fix: |Update: |Rework: Some text`**.

A custom Git `commit-msg` hook is used to validate this pattern, ensuring that commit messages are consistent with project guidelines.

## Setup Instructions

### 1. Clone the Repository

First, clone the repository to your local machine:

   ```bash
   git clone https://github.com/DevOps-Pro-24-09-24/igor-belevtsov.git
   cd igor-belevtsov
   ```

### 2. Create the Commit-msg Hook Script

In the root of the project directory, copy file `git-hooks/commit-msg` to `.git/hooks/commit-msg`.

Make sure the script is executable by running the following command:

   ```bash
   chmod +x .git/hooks/commit-msg
   ```

### 3. Commit Message Pattern

The commit message must adhere to the following pattern:

   ```
   Add: |Created: |Fix: |Update: |Rework: Some text
   ```

Where:

- **`Add: |Created: |Fix: |Update: |Rework:`** is the prefix that means what type of changes maked.
- **`Some text`** is a brief description of the commit.

If the commit message does not match this pattern, the commit will be blocked, and an error message will be displayed.

### 4. Example of Correct Commit Message

An example of a valid commit message would be:

   ```
   Add: Fixed bug in login flow
   ```

### 5. Testing the Hook

To test the hook, simply attempt to commit with a message:

   ```bash
   git commit -m "Add: Added new feature"
   ```

If the message follows the correct pattern, the commit will proceed. Otherwise, the commit will be blocked, and an error message will appear.

### 6. Troubleshooting

#### Hook Not Working

If the commit-msg hook is not being executed:

1. Ensure that the hook file is located at `.git/hooks/commit-msg`.
2. Verify that the hook is executable by running:

   ```bash
   chmod +x .git/hooks/commit-msg
   ```

3. Ensure that the commit message follows the required pattern exactly.

#### Commit Message Does Not Match

If you see the error message indicating that the commit message is incorrect, double-check that:

- The prefix is **`Add: |Created: |Fix: |Update: |Rework:`**.
- There is a descriptive message after the colon.

### 7. Contributing

When contributing to this project, please ensure that all commit messages follow the pattern **`Add: |Created: |Fix: |Update: |Rework: Some text`**. This helps maintain a clear and consistent commit history.

---

## Summary

This setup ensures that all commit messages adhere to a consistent pattern:

- **Commit messages** must follow the format **`Add: |Created: |Fix: |Update: |Rework: Some text`**.
- The pattern is enforced using a custom `commit-msg` Git hook.

By following these steps, you ensure that your commit messages are valid and consistent with the project's guidelines.

---

# Prepare Commit Message Setup

This project enforces a specific commit message pattern to ensure that all commits follow a standardized format. The script will add a project branch prefix name to commit message **`DJ-XXXXX:`**.

A custom Git `prepare-commit-msg` hook is used to add a custom prefix to commit messages that are consistent with project guidelines.

## Setup Instructions

### 1. Clone the Repository

First, clone the repository to your local machine:

   ```bash
   git clone https://github.com/DevOps-Pro-24-09-24/igor-belevtsov.git
   cd igor-belevtsov
   ```

### 2. Create the Prepare-commit-msg Hook Script

In the root of the project directory, copy file `git-hooks/prepare-commit-msg` to `.git/hooks/prepare-commit-msg`.

You can set needed prefix by editing this line in `.git/hooks/prepare-commit-msg` file:

   ```bash
    prefix = f"DJ-000001"
    #prefix = found_obj.group(0) # For automation prefix extraction from current branch name use this line instead of above
   ```
Where:

- **`DJ-000001:`** is the manual input of project prefix.

Make sure the script is executable by running the following command:

   ```bash
   chmod +x .git/hooks/prepare-commit-msg
   ```

### 3. Commit Message Pattern

Script will add a custom project prefix to all commits under this project:

   ```
   DJ-XXXXXX:
   ```

Where:

- **`DJ-XXXXXX:`** is the project prefix.

### 4. Example of Correct Commit Message

An example of a valid commit message would be:

   ```
   Add: Fixed bug in login flow
   ```

### 5. Testing the Hook

To test the hook, simply attempt to commit with a message:

   ```bash
   git commit -m "Add: Added new feature"
   ```

If the message follows the correct pattern, the commit will proceed. Otherwise, the commit will be blocked, and an error message will appear.
