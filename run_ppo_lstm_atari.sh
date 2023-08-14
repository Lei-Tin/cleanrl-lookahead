TIMESTEPS=100000
GAMESFILE="gamesfile.txt"

echo "Installing Dependencies..."

poetry run pip install "gym[atari,accept-rom-license]==0.23.1" "stable-baselines3==1.2.0" "ale-py==0.7.5"

# If we are using stable baselines 1.2.0 with the new numpy version, we have to replace atari_wrappers.py file
echo "Copying atari_wrappers.py..."
cp atari_wrappers_copy.py .venv/lib/python3.8/site-packages/stable_baselines3/common/atari_wrappers.py

echo "Clearing previous run results..."
rm -rf runs/*

echo "Starting PPO w/ LSTM..."

while read p; do
    poetry run python cleanrl/ppo_atari_lstm_lookahead.py --exp-name "$p-Lookahead" --env-id $p --total-timesteps $TIMESTEPS
    poetry run python cleanrl/ppo_atari_lstm.py --exp-name "$p-NoLookahead" --env-id $p --total-timesteps $TIMESTEPS
done < "$GAMESFILE"

tar -cvf results/"ppo_lstm_results_${TIMESTEPS}_$(date '+%Y-%m-%d_%H-%M-%S%z(%Z)').tar" runs $GAMESFILE