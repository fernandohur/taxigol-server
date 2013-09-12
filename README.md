# Taxigol Server

## News

1. As of `1379000411 UTC (GMT)` all controllers extending ApplicationController for API purposes are deprecated. 
Support for them will be removed soon. These controllers will server only for the AdminPanel
2. To protect the server, all controllers extending ApplicationController now require Basic Authentication. 
To enable this setup in your machine please:  

* Open .bashrc, .bash_profile or similar. Preferably use a decent text editor like VIM 
* Add the following lines 

    `export ADMIN_USERNAME="{write the username you want}"`  
    `export ADMIN_PASSWORD="{write the password you want}"`
  
* Run <code>rails c</code>, restart it if it was allready runing
* open your browser, you will be prompted to authenticate 


