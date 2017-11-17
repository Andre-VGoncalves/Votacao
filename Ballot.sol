pragma solidity 0.4.11;

///@title Voting with delegation
contract Ballot {


    // essa struct  esta representando um unico eleitor
    struct Voter {
        uint weight;
        bool voted; // variavel para verificar se a pessoa votou
        address delegate; //a pessoa
        uint vote; // em quem votou indice
    }

    // essa struct é para um unico voto
    struct Proposal {
        bytes32 name;   // byte32 é uma variavel que recebe uma string curta
        uint votCount;  // votos acumulados;
    }

    address public chairperson;

    // armazena a estruturas de 'Voter' para cada candidato possivel
    mapping (address => Voter) public voters;

    // declarando um vetor dinamico da struct Proposal;
    Proposal[] public proposals;


    function Ballot (bytes32[] proposalNames) {

        chairperson = msg.sender;
        voters[chairperson]. weight = 1;

        /* Para cada  nome que foi votado
        cria um objeto e adciona no final da matriz */
        for (uint i = 0; i < proposalNames.length; i++) {
            // criando um objeto temporarios
            // com proposal utilizando metodo push
            // é anexado no final da matriz
            proposals.push (Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    // dar a opção de votar porem esssa função só pode ser chamada por 'chairperson'
    function giveRightToVote (address voter) {
        /* se o argumeto do require for falso é finalizado 
        e reverte as escolhas para uma boa ideia usar essa função se forem chamadas incorretamente
        ficar atendo pos consumira todo ether fornecido*/
        require((msg.sender == chairperson) && !voters[voter].voted && (voters[voter].weight == 0));
        voters[voter].weight = 1;
    }

    function delegate (address to) {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted);

        // se auto-delegar não é permitido;
        require(to != msg.sender);

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender);
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate = voters[to];

        if (delegate.voted) {
            proposals[delegate.vote].voteCount += sender.weight;
        }else {
            delegate.weight += sender.weight;
        }
    }

    function vote (uint proposal) {
        Voter storage sender = voters = voters[msg.sender];
        require(!sender.voted);
        sender.voted = true;
        sender.vote = proposal; 

        proposals[proposal].voteCount += sender.weight;
    }

    ///@dev computes the winning proposal taking all

    function winningProposal() constant
    returns (uint winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposal.length; p++) {
            winningVoteCount = proposals[p].voteCount;
            winningProposal = p;
        }
    }

    function winnerName() constant
        returns (bytes32 winnerName)
    {
        winnerName = proposals[winningProposal()].name;
    }

}