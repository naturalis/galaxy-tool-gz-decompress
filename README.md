# galaxy-tool-gz-decompress
convert fastq.gz.zip to fastq.zip  

## Installation
### Manual  
Clone this repo in your Galaxy ***Tools*** directory:  
`git clone https://github.com/naturalis/galaxy-tool-gz-decompress`  

Make sure the script is executable:  
`chmod 755 galaxy-tool-gz-decompress/gz-decomp.sh`  

Append the file ***tool_conf.xml***:    
`<tool file="/path/to/Tools/galaxy-tool-gz-decompress/gz-decomp.xml" />`  

### Ansible
Depending on your setup the [ansible.builtin.git](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html) module could be used.  
[Install the tool](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html#examples) by including the following in your dedicated ***.yml** file:  

`  - repo: https://github.com/naturalis/galaxy-tool-gz-decompress`  
&ensp;&ensp;`file: gz-decomp.xml`  
&ensp;&ensp;`version: master`  
