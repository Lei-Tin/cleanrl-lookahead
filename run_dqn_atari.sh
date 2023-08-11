TIMESTEPS=100000
GAMESFILE="gamesfile.txt"

echo "Installing Dependencies..."
poetry run pip install "stable_baselines3==2.0.0a1" "gymnasium[atari,accept-rom-license]==0.28.1"  "ale-py==0.8.1"

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting DQN..."

while read p; do
    poetry run python cleanrl/dqn_atari_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/dqn_atari.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"

tar -cvf results/"dqn_results_${TIMESTEPS}_$(date '+%Y-%m-%d_%H-%M-%S%z(%Z)').tar" runs $GAMESFILE