#!/bin/bash

if dpkg -s "openssh-server" &> /dev/null; then
    echo "openssh-server installed"
else
    echo "Installing openssh-server"
    apt-get install -y openssh-server
fi

if dpkg -s "knockd" &> /dev/null; then
    echo "knockd installed"
else
    echo "Installing knockd"
    apt-get install -y knockd
fi

echo "editing knock configuration file..."
file="/etc/knockd.conf"
line_number=5

new_line="sequence = 10005,10006,10007"

temp_file=$(mktemp)
cat "$file" | awk -v n="$line_number" -v new_line="$new_line" '{ if (NR == n) { print new_line; } else { print $0; } }' > "$temp_file"
mv "$temp_file" "$file"

file="/etc/knockd.conf"
line_number=11
new_line="sequence = 10007,10006,10005"
temp_file=$(mktemp)
cat "$file" | awk -v n="$line_number" -v new_line="$new_line" '{ if (NR == n) { print new_line; } else { print $0; } }' > "$temp_file"
mv "$temp_file" "$file"

file="/etc/knockd.conf"
line_number=7
new_line="command = /sbin/iptables -I INPUT -s %IP% -p tcp --dport 22 -j ACCEPT"
temp_file=$(mktemp)
cat "$file" | awk -v n="$line_number" -v new_line="$new_line" '{ if (NR == n) { print new_line; } else { print $0; } }' > "$temp_file"
mv "$temp_file" "$file"
sleep 3
echo "setting up the network interface card..."
file="/etc/default/knockd"
line_number=5
new_line="START_KNOCKD=1"
temp_file=$(mktemp)
cat "$file" | awk -v n="$line_number" -v new_line="$new_line" '{ if (NR == n) { print new_line; } else { print $0; } }' > "$temp_file"
mv "$temp_file" "$file"

read -p "enter the name of the network card you want to use[default eth nic]: " nic
nic=${nic:-$(ip link | awk -F: '$0 !~ "lo|vir|wl|docker|^[^0-9]"{print $2;getline}')}
file="/etc/default/knockd"
line_number=8
new_line="KNOCKD_OPTS = \"-i $nic\""
temp_file=$(mktemp)
cat "$file" | awk -v n="$line_number" -v new_line="$new_line" '{ if (NR == n) { print new_line; } else { print $0; } }' > "$temp_file"
mv "$temp_file" "$file"

sleep 3
echo "starting knock service"
systemctl start knockd
systemctl enable knockd

sleep 3
echo "configuring firewall"
ufw enable

port=22
status=$(sudo ufw status | grep $port)
if [ -n "$status" ]; then
  echo "Port $port is open, closing it..."
  sudo ufw deny $port
  echo "Port $port closed."
else
  echo "Port $port is closed."
fi

echo "knock service is up with opening sequence 10005,10006,10007 and closing sequence 10007,10006,10005"

