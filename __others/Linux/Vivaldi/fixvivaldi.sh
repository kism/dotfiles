sudo cp custom.css /opt/vivaldi/resources/vivaldi/style/custom.css
sudo sed -i '1s/^/@import "custom.css";/' /opt/vivaldi/resources/vivaldi/style/common.css
echo "Done!"
