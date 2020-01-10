#SSH Keygen
`ssh-keygen -t ed25519 -a 100 -C "Comment"`


# Step One—Create the RSA Key Pair
`ssh-keygen -t rsa`

# Step Two—Store the Keys and Passphrase  
Default

# Step Three—Copy the Public Key  
`ssh-copy-id demo@198.51.100.0`  

# Alternative method
`cat ~/.ssh/id_rsa.pub | ssh demo@198.51.100.0 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"`
