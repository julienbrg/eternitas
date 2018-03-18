# Eternitas
Eternitas is a service for will execution via smart contracts.

Some functions of the main contract are inspired from [Heritable.sol](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Heritable.sol) by [Open Zeppelin](https://openzeppelin.org/).

Website: [http://eternitas.io/](http://eternitas.io/)
## Test
Before testing Eternitas, make sure you have the following apps installed: 

**Truffle**

    npm install -g truffle
**Testrpc**

    npm install -g ethereumjs-testrpc

Then test it:

    truffle compile
    truffle migrate
    truffle test

## User workflow

 1. The user edits his last wills on a dedicated page (a form on
    [http://eternitas.io/](http://eternitas.io/)).
 2. A smart contract is deployed on the blockchain: his last wills are secured on the blockchain.
3. He can select the proportion to give to each heir for each asset.
4. His death triggers several transactions from the main contract to his heirs.

## Description

    struct Heir
        {
            uint shares;
            uint relationship; // 0 : Child 1: Spouse 2: Other
        }



```relationship``` indicates the relationship between the owner (testator) and his heirs. "0" is a child, "1"
```shares``` indicates the proportion of an asset (ETH only on this version) to be transferred to this heir.



```haertbeatTimeout```

```timeOfDeath```

```totalShares```

```heirs_```

```Owner```

```transferOwnership```

```addHeir```

```reclaimFunds```

```proclaimDeath```

## The problems we solved
 - NO loss of control over the own will in case of death: Our „smart
   will“ continues to exist and to work beyond the death of the
   testator, allowing full control on the distribution of the different
   assets in accordance to the last will. The testator becomes his own
   will executor. People die, code lives on.
   
  -  NO human third party risks: leaving the execution of a will to the
   heirs themselves provokes misunderstandings and conflicts
   (statistically in around 30% of the cases); will executors could
   themselves fail to act in conformity with the testator, either
   because of a collusion with one of the heirs, either because of their
   own incapacity or refusal. No one can alter the last will of the
   testator.
   
   - NO complicated inventory: real life assets have to be searched for,
   which is onerous. Digital or tokenized assets may ideally be all on
   one platform. This means, the inventory is already made by the
   account owner, who is his own estate manager during lifetime.
   
   - NO need to wait eternally: making an inventory and distributing the
   funds can take 1 or 2 years or longer. That´s the time, the heirs
   have to wait without having access to the funds. We may cut this
   period down to seconds. 
   
  -  NO costs, that will kill you: will executors or estate managers
   generally act on a commission based model and may in a lot of
   countries fix their fees freely (3, 5, 10% or more for execution
   only); additional actions may be charged further. We can cut costs
   significantly by the automatisation of this transaction. Notaries or
   lawyers may only be included in this process during the will creation
   (if the customer asks for their help) or for the enregistration of
   the ownership of certain assets (e.g. real estate).
   
  -  NO loss of funds anymore:  cryptoassets will not be lost in case of
   death any more, as every heir gets notified, that he can reclaim his
   funds.
