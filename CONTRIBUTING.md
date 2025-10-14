# Contributing to QuestLog

First off, thank you for considering contributing to QuestLog! 🎮

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if possible**
- **Include your environment details** (Flutter version, device, OS)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other apps** (if applicable)

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Follow the existing code style**
   - Use meaningful variable names
   - Add comments for complex logic
   - Follow Flutter/Dart best practices
3. **Test your changes thoroughly**
   - Test on both Android and iOS if possible
   - Ensure no existing features are broken
4. **Update documentation** if needed
5. **Write a clear commit message**

## Development Setup

1. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/questlog.git
   cd questlog
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create `.env` file with your RAWG API key

4. Run the app:
   ```bash
   flutter run
   ```

## Code Style Guidelines

- Use **2 spaces** for indentation
- Follow **Dart naming conventions**:
  - Classes: `PascalCase`
  - Variables/functions: `camelCase`
  - Constants: `camelCase` with `const`
- Add **comments** for complex logic
- Keep functions **small and focused**
- Use **meaningful names** for variables and functions

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # Business logic & API calls
├── widgets/         # Reusable widgets
└── theme/           # App theming
```

## Commit Message Guidelines

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests when relevant

Examples:
```
Add game screenshots gallery feature
Fix collection not updating on physical devices
Update README with installation instructions
```

## Questions?

Feel free to open an issue with the `question` label!

---

Thank you for contributing! 🙏
