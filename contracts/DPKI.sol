pragma solidity ^0.4.16;

contract DPKI {

    function DPKI(){

    }

    struct DCP {
        /*  DOMAIN CERTIFICATE POLICY (DCP)
        *    Domain name identify domain for which the policy is active
        *    Valid from specify start period of DCP’s validity
        *    Version number identify version of this domain’s DCP
        *    Payout address authenticate and receive payments for domain
        *    Check Contract address of the DCP’s check contract
        *    Update addresses (default empty) authorize DCP updates
        *    Update threshold (default 1) threshold of payout/update addrs. for DCP updates
        */

    }

    function RegisterDCP() public {

    }

    function UpdateDCP() public {

    }

    struct CA {

    }

    function RegisterCA() public {

    }

    function UpdateCA() public {

    }

    function GetCABalance() public {

    }

    struct RP {
        /*  REACTION POLICY (RP)
        *    Domain name identify domain for which the RP is active
        *    Issuer CA who issued the RP
        *    Valid from specify start period of RP’s validity
        *    Valid to specify start period of RP’s validity
        *    Version number version of domain’s DCP used to trigger RP
        *    Reaction Contract address of the RP’s reaction contract
        */
    }


    function OrderRP() public {

    }

    function CreateRP() public {

    }

    function TerminateRP() public {

    }

    function ExpireRP() public {

    }

    function ReportCertificate() public {

    }

    function SendPayouts() public {

    }


}
