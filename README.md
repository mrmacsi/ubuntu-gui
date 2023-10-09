# ubuntu-gui
ubuntu tls gui

wget -O - https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/setup.sh | bash


nohup sh -c "wget -O - https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/setup.sh | bash" & 


sudo apt update
sudo apt install python3 curl

wget -O - https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/cursor.py | python3

python3 cursor_overlay.py


xhost +local:
