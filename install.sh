#!/data/data/com.termux/files/usr/bin/bash

echo "Installing CalX..."

# Copy calx.sh to $PREFIX/bin for global access
cp calx.sh $PREFIX/bin/calx
chmod +x $PREFIX/bin/calx

echo "CalX installed successfully!"
echo "You can now run it with the command 'calx'."
