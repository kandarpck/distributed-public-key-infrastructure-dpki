pragma solidity ^0.4.16;
contract IKP {
    struct DomainCertificatePolicy {
        /*  DOMAIN CERTIFICATE POLICY (DCP)
        *    Domain name identify domain for which the policy is active
        *    CA who is authorised to issue DCP
        *    data CERTIFICATE or domain
        *    identifier indentify whether you are passing in a domain or a cert
        */
        address owner;
        string identifier;
        string data;
        string certHash;
        uint certExpiry;
        address CA;
    }

    struct CertificateAuthority {
        /*  CertificateAuthority (CA)
        *   Domain name identify domain for which the RP is active
        *   CAOwner owner of the CA 
        */
        address caOwner;
        string caName;
    }
    
    struct ReactionPolicy {
        /*  REACTION POLICY (RP)
        *    Domain name identify domain for which the RP is active
        *    Issuer CA who issued the RP
        *    Valid from specify start period of RP’s validity
        *    Valid to specify start period of RP’s validity
        */
        address signer;
        address CA;
        uint attributeID;
        uint expiry;
    }

    struct Revocation {
        /* 
        *   Revoke the malicious Certificate
        */
        uint rpID;
        string certHash;
        address CA;
    }

    struct Detector {
        /*
        *   Higher authority that has the power to revoke certs in addition to the CA
        */
        
        address authority;
    }
    
    DomainCertificatePolicy[] public dcps;
    ReactionPolicy[] public rps;
    Revocation[] public revocations;
    Detector[] public detectors;
    CertificateAuthority[] public cas;
    
    event DCPAdded(uint indexed attributeID, address indexed owner, string identifier, string data, string certHash, uint certExpiry, address CA);
    event RPSigned(uint indexed signatureID, address indexed signer, address CA, uint indexed attributeID, uint expiry);
    event SignatureRevoked(uint indexed revocationID, string certHash, uint indexed reactionPolicyID, address caAddress);
    event DetectorAdded(uint indexed detectorID, address indexed authority);
    event CAAdded(uint indexed caID, address indexed CAOwner, string name);
    event CABlacklisted(uint caIndex, uint detectorIndex);
    
    function addDetector(address detectorAddress) public returns (uint detectorID) {
        detectorID = detectors.length++;
        Detector storage detector = detectors[detectorID];
        detector.authority = detectorAddress;
        emit DetectorAdded(detectorID, detectorAddress);
    }
    
    function getDetectorCount() public constant returns(uint) {
        return detectors.length;
    }

    function getDetector(uint index) public constant returns(address) {
        return (detectors[index].authority);
    }
    
    function registerCA(address caAddress, string caName) public returns (uint caID){
        caID = cas.length++;
        CertificateAuthority storage ca = cas[caID];
        ca.caOwner = caAddress;
        ca.caName = caName;
        emit CAAdded(caID, caAddress, caName);
    }
    
    function getCACount() public constant returns(uint) {
        return cas.length;
    }

    function getCA(uint index) public constant returns(address, string) {
        return (cas[index].caOwner, cas[index].caName);
    }
    
    function blacklistCA(uint caIndex, uint detectorIndex) public {
    // detectors can blacklist CAs if they breach a threshold.
    if (detectors[detectorIndex].authority == msg.sender) {
      if (cas.length > 1) {
        cas[caIndex] = cas[cas.length-1];
        delete(cas[cas.length-1]); 
      }
      cas.length--;
    }
        emit CABlacklisted(caIndex, detectorIndex);
    }

    function registerDCP(string identifier, string data, string certHash, uint certExpiry, address CA) public returns (uint dcpID) {
        dcpID = dcps.length++;
        DomainCertificatePolicy storage dcp = dcps[dcpID];
        dcp.identifier = identifier;
        dcp.owner = msg.sender;
        dcp.data = data;
        dcp.CA = CA;
        dcp.certHash = certHash;
        dcp.certExpiry = certExpiry;
        emit DCPAdded(dcpID, msg.sender, identifier, data, certHash, certExpiry, CA);
    }
    
    function getDCPCount() public constant returns(uint) {
        return dcps.length;
    }

    function getDCP(uint index) public constant returns(address, string, string, string, uint, address) {
        return (dcps[index].owner, dcps[index].identifier, dcps[index].data, dcps[index].certHash, dcps[index].certExpiry, dcps[index].CA);
    }
    
    function signRP(uint dcpID, uint expiry) public returns (uint signatureID) {
        if (dcps[dcpID].CA == msg.sender) {
            signatureID = rps.length++;
            ReactionPolicy storage rp = rps[signatureID];
            rp.CA = dcps[dcpID].CA;
            rp.signer = msg.sender;
            rp.attributeID = dcpID;
            rp.expiry = expiry;
            emit RPSigned(signatureID, msg.sender, rp.CA, dcpID, expiry);
        }
    }

    function getRPCount() public constant returns(uint) {
        return rps.length;
    }

    function getRP(uint index) public constant returns(address, address, uint, uint) {
        return (rps[index].signer, rps[index].CA, rps[index].attributeID, rps[index].expiry);
    }
    
    function revokeSignature(uint reactionPolicyID, string certHash, address caAddress, uint detectorIndex) public returns (uint revocationID) {
        if (rps[reactionPolicyID].signer == msg.sender || detectors[detectorIndex].authority == msg.sender) {
            revocationID = revocations.length++;
            Revocation storage revocation = revocations[revocationID];
            revocation.rpID = reactionPolicyID;
            revocation.certHash = certHash;
            revocation.CA = caAddress;
            emit SignatureRevoked(revocationID, certHash, reactionPolicyID, caAddress);
        }
    }
    
    function getRevokedCount() public constant returns(uint) {
        return revocations.length;
    }

    function getRevokedCerts(uint index) public constant returns(uint, string, address) {
        return (revocations[index].rpID, revocations[index].certHash, revocations[index].CA);
    }
    
}