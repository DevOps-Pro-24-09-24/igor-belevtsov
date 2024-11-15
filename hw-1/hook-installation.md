# HW-1 : Git hooks and linting

## Linting & YAML Validation Setup

This project uses `flake8` (for trailing whitespaces) & `yamllint` (YAML formatting), automated via `pre-commit` hooks.

### Setup
1. **Clone Repository**:
   ```bash
   git clone https://github.com/DevOps-Pro-24-09-24/igor-belevtsov.git && cd igor-belevtsov
   ```
2. **Install Dependencies**:
   ```bash
   pip3 install -r requirements.txt  # or poetry install
   ```
3. **Install Pre-commit Hooks**:
   ```bash
   pre-commit install
   ```

### Usage
1. **Commit Code**:
   ```bash
   git add <files> && git commit -m "Your message"
   ```
2. **Manual Linting (Optional)**:
   ```bash
   pre-commit run --all-files
   ```

---

## Commit Message Validation

### Commit Pattern: `Add: |Created: |Fix: |Update: |Rework: <text>`

### Setup
1. Copy `git-hooks/commit-msg` to `.git/hooks/commit-msg`.
2. Make it executable:
   ```bash
   chmod +x .git/hooks/commit-msg
   ```

---

## Prepare Commit Message Hook

### Auto-add Prefix: `DJ-XXXXX:`

### Setup
1. Copy `git-hooks/prepare-commit-msg` to `.git/hooks/prepare-commit-msg`.
2. Edit prefix in script:
   ```python
   prefix = "DJ-000001"
   ```
3. Make it executable:
   ```bash
   chmod +x .git/hooks/prepare-commit-msg
   ```