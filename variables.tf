//You will need to create a key pair in IAM services make sure you keep  
//the private key, it will only be available the one time.

//AWS login access key
variable "access_key" {
    type = string
    default = "" //<---- Access key string
}

//AWS login private key
variable "private_key" {
    type = string
    default = "" //<---- Private key string
}


//****You will need to go to EC2 > Key Pairs in AWS and create a key pair.**** 
//Make sure you create the key as a .pem key.
//Create a sub dir from the main.tf file called "key" and place your .pem key file there.
//Make sure the .pem is named the same as what is in aws (It will be the same by default. Don't change it)
//You may need to change permissions to 400 for .pem key and/or "key" subfolder.
variable "ssh_key_name" {
    type = string
    default = "" //<---- Example: aws-main-access-key
}


//****This is only required if you want to clone a repo. No required.
//To clone a repo to your ansible server copy the repo link as the default string
variable "clone_git_repo_link" {
    type = string
    default = ""
    //Example: "https://github.com/username/myrepo/git"
}


