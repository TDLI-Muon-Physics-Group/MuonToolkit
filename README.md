# Physics Software Stack Installer

A comprehensive bash script to install ROOT, Geant4, and CLHEP for particle physics simulation and data analysis.

## 🚀 Quick Start

```bash
# Download the installer and configuration file
# Make the script executable
chmod +x install_physics_stack.sh
```

# Run the installer

````bash
./install_physics_stack.sh
```

## 📋 Quick Start

### macOS
- Homebrew (automatically installed if missing)
- Xcode Command Line Tools

### Linux
- Basic build tools (gcc, g++, make)

## ⚙️  Installation Options

### Command Line Arguments

```bash
./install_physics_stack.sh --prefix /custom/path
./install_physics_stack.sh --no-root          # Skip ROOT
./install_physics_stack.sh --no-geant4        # Skip Geant4
./install_physics_stack.sh --no-clhep         # Skip CLHEP
./install_physics_stack.sh --show-config      # Show config only
```

### Environment Variables

```bash
export INSTALL_PREFIX="/custom/path"
export INSTALL_ROOT=0           # Use system version
export INSTALL_GEANT4=0         # Use system version
export INSTALL_CLHEP=0          # Use system version
./install_physics_stack.sh
```

## 🛠️  Features

- Cross-Platform: macOS, Ubuntu, Debian, RedHat, CentOS, Fedora, Arch
- Auto-Dependency Management: Installs system dependencies automatically
- Parallel Builds: Uses all CPU cores
- Error Handling: Comprehensive error checking
- Smart Detection: Uses system libraries when available

## 📦 Software Versions

- ROOT: 6.28.12 (Data analysis framework)
- Geant4: 11.3.2 (Particle physics simulation)
- CLHEP: 2.4.6.0 (High Energy Physics library)

## 📁 Directory Structure

```text
MuonToolKits/
├── install_physics_stack.sh    # Main installer
├── dependencies.conf          # Configuration
└── patch/                     # Optional patches
```

## 🧪 Verification

```bash
source ~/.bashrc
root --version
geant4-config --version
```

## 🔄 Updates

Edit ```dependencies.conf``` with new versions and rerun the installer.

## 📚 Documentation

- [ROOT Documentation](https://root.cern/install/build_from_source/)
- [Geant4 Documentation](https://geant4.web.cern.ch)
- [CLHEP](https://proj-clhep.web.cern.ch/proj-clhep/)

## 🤝 Support

1. Run with debug: ```DEBUG=1 ./install_physics_stack.sh```
2. Check individual software documentation

Note: For research and educational use. Verify installations before production use.


