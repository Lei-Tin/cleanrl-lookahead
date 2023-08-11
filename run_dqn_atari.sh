TIMESTEPS=100000
GAMESFILE="gamesfile.txt"

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting DQN..."

while read p; do
    poetry run python cleanrl/dqn_atari_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/dqn_atari.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"

tar -cvf results/"dqn_results_$(date '+%Y-%m-%d_%H-%M-%S%z(%Z)').tar" runs $GAMESFILE