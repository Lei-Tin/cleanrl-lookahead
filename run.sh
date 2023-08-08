TIMESTEPS=50000
GAMESFILE="gamesfile.txt"

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting..."

while read p; do
    poetry run python cleanrl/ppo_atari_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/ppo_atari.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"