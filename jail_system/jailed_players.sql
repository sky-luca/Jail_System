-- Create jailed_players table for storing jail information
CREATE TABLE `jailed_players` (
    `license` VARCHAR(255) PRIMARY KEY,    -- Unique identifier for the player's license
    `playerName` VARCHAR(50) NOT NULL,     -- Name of the jailed player
    `timeRemaining` INT NOT NULL           -- Time remaining in jail in seconds
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional: Add an index for faster lookups on the license
CREATE INDEX `idx_license` ON `jailed_players` (`license`);
