TIMESTEPS=100000
GAMESFILE="gamesfile.txt"

echo "Installing Dependencies..."
poetry run pip install "stable_baselines3==2.0.0a1" "gymnasium[atari,accept-rom-license]==0.28.1"  "ale-py==0.8.1"

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting C51..."

while read p; do
    poetry run python cleanrl/c51_atari_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/c51_atari.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"

tar -cvf results/"c51_results_${TIMESTEPS}_$(date '+%Y-%m-%d_%H-%M-%S%z(%Z)').tar" runs $GAMESFILE