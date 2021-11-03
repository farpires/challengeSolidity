// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IGame {
    struct Player {
        address addressPlayer;
        string name;
        string surName;
        uint256 points;
        uint256 reward;
        address gameAddress;
    }

    struct Game {
        string nameGamer;
        uint256 timestampBegin;
        uint256 timestampEnd;
        uint256 countGamer;
        bool tableCompletionFlag;
    }

    struct InitialGame {
        address addressGame;
    }

    function getLifetimeScore(address player, uint256 _id)
        external
        returns (bool);

    function update(uint256 leaderboardId) external;
}

contract Leaderboard is IGame {
    // contador hasta 10
    uint256 public count;
    uint256 public countPlayer;
    // juego
    mapping(address => Game) public games;
    mapping(address => bool) public joinedGames;
    mapping(uint256 => InitialGame) public initialGames;
    // jugador
    mapping(uint256 => Player) public players;
    mapping(address => bool) public joinerPlayers;
    mapping(uint256 => Player) public playerAux;

    // agregar juego
    function addGamingPlatform(
        address _gameAddress,
        string memory _nameGamer,
        uint256 _timestampBegin,
        uint256 _timestampEnd
    ) public {
        require(!gameJoined(_gameAddress));
        Game storage game = games[_gameAddress];
        game.nameGamer = _nameGamer;
        game.timestampBegin = _timestampBegin;
        game.timestampEnd = _timestampEnd;
        joinedGames[_gameAddress] = true;
    }

    function gameJoined(address addr) private view returns (bool) {
        return joinedGames[addr];
    }

    /**agregar jugador */
    function addPlayer(
        address _gameAddress,
        address _player,
        string memory _name,
        string memory _surName
    ) public returns (bool flag) {
        require(gameJoined(_gameAddress));
        Game storage game = games[_gameAddress];
        if (game.tableCompletionFlag == false && game.countGamer <= 10) {
            game.countGamer++;
            require(!playersJoined(_player));
            Player storage player = players[countPlayer];
            player.addressPlayer = _player;
            player.name = _name;
            player.surName = _surName;
            player.gameAddress = _gameAddress;
            countPlayer++; //ver
            joinerPlayers[_player] = true;
            return true;
        } else if (game.tableCompletionFlag == false) {
            createBoard(
                _gameAddress,
                block.timestamp,
                block.timestamp + 864000
            );
            count++;
            return false;
        }
    }

    function playersJoined(address addr) private view returns (bool) {
        return joinerPlayers[addr];
    }

    /**start juego */

    function createBoard(
        address _gameAddress,
        uint256 _timestampBegin,
        uint256 _timestampEnd
    ) public {
        Game storage game = games[_gameAddress];
        game.timestampBegin = _timestampBegin;
        game.timestampEnd = _timestampEnd;
    }

    function getLifetimeScore(address _player, uint256 _id)
        public
        override
        returns (bool flag)
    {
        require(!playersJoined(_player));
        Player storage player = players[_id];
        Game storage game = games[player.gameAddress];
        if (block.timestamp >= game.timestampEnd + 864000) {
            game.tableCompletionFlag = true;
            return true;
        } else {
            return false;
        }
    }

    function rewardSum() private {
        for (uint256 j = 0; j < 10; j++) {
            players[j].reward = players[j].points * (10 - j);
            // Recompensa = PUNTOS * (MAX_PLAYERS - POSICION)
        }
    }

    function update(uint256 leaderboardId) public override {
        InitialGame storage initialGame = initialGames[leaderboardId];
        Game storage game = games[initialGame.addressGame];
        if (game.tableCompletionFlag == false) {
            for (uint256 i = 0; i < 10; i++) {
                if (players[i].gameAddress == initialGame.addressGame) {
                    bool flagAux = getLifetimeScore(
                        players[i].addressPlayer,
                        i
                    );
                    if (flagAux == false) {
                        //ordenado por metodo burbuja
                        if (players[i].points < players[i + 1].points) {
                            playerAux[0] = players[i + 1];
                            players[i + 1] = players[i];
                            players[i] = playerAux[0];
                        }
                    } else {
                        rewardSum();
                        break;
                    }
                }
            }
        }
    }
}
