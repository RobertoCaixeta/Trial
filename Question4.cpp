void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    //The memory leak is because the pointer player, he is invoked but never deleted
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // If the load fails, relase the alocated memory 
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    // If the player is not necessary, free the memory
    delete player;
}