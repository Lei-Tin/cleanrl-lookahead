TIMESTEPS=100000
GAMESFILE="gamesfile.txt"

echo "Installing Dependencies..."
poetry run pip install "gym[atari,accept-rom-license]==0.23.1" "stable-baselines3==1.2.0" "ale-py==0.7.5"

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting PPO..."

while read p; do
    poetry run python cleanrl/ppo_atari_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/ppo_atari.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"

tar -cvf results/"ppo_results_${TIMESTEPS}_$(date '+%Y-%m-%d_%H-%M-%S%z(%Z)').tar" runs $GAMESFILE