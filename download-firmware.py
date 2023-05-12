import requests
import random
from bs4 import BeautifulSoup

url = "https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-9"
response = requests.get(url)
mirror_list = response.text.split("\n")
mirror = random.choice(mirror_list)
print("Selected mirror: "+mirror)

response = requests.get(mirror+"/Packages/l/")
soup = BeautifulSoup(response.text, 'html.parser')
for link in soup.find_all('a'):
    if 'linux-firmware-2' in link.get('href'):
        rpm_url = f"{mirror}/Packages/l/{link.get('href')}"
        break

print("Final download URL: "+rpm_url)

response = requests.get(rpm_url)
with open("linux-firmware.rpm", "wb") as f:
    f.write(response.content)