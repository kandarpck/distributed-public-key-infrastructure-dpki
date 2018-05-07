# Distributed Public Key Infrastructure (DPKI)
Blockchain-based PKI enhancement

In this project we will demonstrate a prototype of how Decentralized Public Key Infras-tructure (DPKI) and its security features would look like.  DPKI as an idea took shape atone of the Reboot Web of Trusts workshops in 2015.  In today’s Internet,  there is a hugesecurity risk by having identities (email addresses, domain names, usernames etc.)  storedin  centralized  systems  such  as  Certificate  Authorities,  Domain  Name  System  servers  etc.Through  DPKI,  the  idea  is  to  return  the  ownership  of  the  identity  to  the  users  who  areusing  it.   It  achieves  this  using  decentralization  (blockchain)  technology.   This  allows  for “permissionless bootstrapping” of identity and has significant security enhancements whencompared to PKI. For this project, our prototype will include a basic network that needs tocommunicate over a custom SSL channel (we call it SSL Lite) which uses DPKI instead ofPKI. Within the scope of this project, we will also outline any challenges/limitations thatwe come across that could prevent this technology from being widely adopted.

# Accounts
Below are the main actors in the IKP implementation.

    * The main account or account 0 which is the default while running the Ethereum smart contracts.
    * Detector which has the authority to detect and report rogue CA, revoke certificates and blacklist CAs. 
    * Multiple CAs which are used to register the domains.
    * Domain Owners who want to register their domain on the Blockchain.

#Setup
Below is the screenshot of the setup used in implementing the solution. Here are the main technologies used from left to right and top to bottom.

    * A private subnet which runs a local version of the Blockchain and has local nodes and miners.
    * A user interface (Mist Browser) which can talk to the local version of the Blockchain and display the various components, accounts, contracts, among other items
    * Console interface to send commands to the Blockchain. There are multiple such interfaces possible. This is the console API while we will also use the Javascript Web3 API when we create the Chrome Plugin below.
    * A node server to display the User Interface on http://localhost:3000
    * Truffle interface to compile, build and deploy contracts and test them.


#IKP Smart Contract
The below screenshot shows the IKP smart contract and all the functions possible.

    * Add a detector and register it.
    * Register CAs which can be used by the domain owners to issues certificates.
    * Register DCPs with the CAs.
    * Create an associated RP which is a contract when errors are detected to send payouts.
    * Revoke certificates when the detector receives a report of a malicious certificate in the wild.
    * Detector also has a power to Blacklist CAs when a rogue CA misbehaves multiple times and matches a criteria.
    
        
#Register CA
We can register multiple CAs but for this implementation we show a Good CA and a Rogue CA. 


#Register DCP
Two DCPs are shown here. Multiple other scenarios are possible but these two cover the cases we want to present.

    * Normal scenario where domain owner registers a DCP with a CA of choice.
    * Malicious scenario where a Rogue CA issues a certificate without the knowledge of the original domain owner.


#Sign RP
The DCPs are not valid until they are signed with a reaction policy. The SignRP function was used here to sign the above DCPs. One important detail to note here is that any CA can sign the RP and publish it on the Blockchain. But the detector when it detects the malicious intentions can take action against the cert and the CA. Here, the Rogue CA has signed the DCP with badssl-google.com which it can then use in conjunction with an adversary to perform MITM attacks. 


#Detectors
These are entities such as Google which when received with a report of a malicious acitivity on the IKP, investigate using the public blocks of the system and can take action if found guilty and trigger the reaction policy.

    
#Revoke Signature
Here we show an example of the Detector revoking the certificate using the Hash and the CA address. It also builds a profile of the CAs and keeps a check on their activites and is in the position to rate them too. 


#Blacklist CA
Here we show an example of the Detector using the profile that it built from the revoking certs in the previous example. When a certain threshold is breached (which can be tweaked), the Detector can Blacklist the CA which will remove it from the IKP Blockchain and no other domain owner can request certificates from it. 


#Chrome Plugin
We developed a Chrome Browser Plugin which talks to the Blockchain using the JS Web3 API. When any user visits a website which has a known rogue certificate in the revoked certificate list, the plugin automatically checks the hash of the certificate and alerts the user of a MITM attack. The major incentive for the user to install this plugin is that he does not have to create an account on the Ethereum network and there is no fee(gas used) associated with checking the Blockchain. 


#Web Dashboard
A future scope could be an implementation of a more detailed version of the Chrome Plugin created in a similar way using JS and Web3 to interact and automate the process for each of the actors in the system. For this implementation, the Mist browser provides all the same functionality to perform the task in a private virtual VM environment mode.  

