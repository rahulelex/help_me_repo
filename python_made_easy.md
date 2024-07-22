curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python2.7 get-pip.py
pip2 install bottle
pip install gunicorn
pip install requests


sudo apt-get install curl -y && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && sudo python2.7 get-pip.py
sudo pip2 install bottle


---
[ERROR - conan syntax error]
[Solution: python was installed in python 2, but development was in python 3. So remove conan using 'pip2 uninstall conan' and
use below commands to install conan in python3]
```sh
cat conan_inst.sh 
sudo apt install python3 python3-pip -y
sudo python3 -m pip install conan
conan config set general.revisions_enabled=1
conan profile new default --detect > /dev/null
conan profile update settings.compiler.libcxx=libstdc++11 default
```
---

# Find all requirements and save them in requirements.txt
```sh
pipreqs
```