#!/usr/bin/env sh

# Check out and update
echo "Checking out and updating the stable-diffusion-webui repository"
cd /dockerx
if [ -d "stable-diffusion-webui" ]; then
  cd stable-diffusion-webui
  git fetch --all
  git pull # should you ever get stuck here, delete the ./data directory locally and try again
else
  git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
  cd stable-diffusion-webui
fi

# Preserve model files
if [ -d "/dockerx/stable-diffusion-webui/models" ]; then
  echo "Moving models out of repo before patching"
  mv /dockerx/stable-diffusion-webui/models /dockerx/models # Speeds up the patching process a bit
fi

# Patch code for changes in pytorch_lightning
echo "Patching pytorch_lightning"
find /dockerx/stable-diffusion-webui -type f -exec sed -i 's/from pytorch_lightning.utilities.distributed import rank_zero_only/from pytorch_lightning.utilities.rank_zero import rank_zero_only/g' {} +

# Restore model files
if [ -d "/dockerx/models" ]; then
  echo "Moving models back into repo after patching"
  mv /dockerx/models /dockerx/stable-diffusion-webui/models
fi

# Install python packages (additionally install timm and python3.10-venv packages)
echo "Installing python packages"
python -m pip install --upgrade pip wheel timm python3.10-venv

# Run the webui
echo "Running the webui"
bash ./webui.sh --precision full --no-half
