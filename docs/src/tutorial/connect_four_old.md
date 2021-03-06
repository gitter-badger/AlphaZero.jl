# Learning to Play Connect Four

In this section, we discuss how to use `AlphaZero.jl` to learn to play
_Connect Four_ without any form of supervision or prior knowledge.
Although the game has been [solved](https://connect4.gamesolver.org/) exactly
with Alpha-beta pruning using domain-specific heuristics and optimizations, it
is still a great challenge for reinforcement learning.[^1]

[^1]:
    To the best of our knowledge, none of the many existing Python
    implementations of AlphaZero are able to learn a player that beats a
    minmax baseline that plans at depth 2 on a single desktop computer.

Before you continue,
we recommend that you read a high-level introduction such as
[this one](https://web.stanford.edu/~surag/posts/alphazero.html)
if you are not already familiar with AlphaZero.
In this tutorial, we are going to:

  1. Show you how to train a Connect Four agent on your own machine using
     the `AlphaZero.jl` package.
  1. Give instructions to launch a training session on your machine
  2. Discuss hyperparameters tuning
  3. Analyze the results
  4. Give an overview of `AlphaZero.jl` codebase.

## Running a Training Session

To replicate the experiment in this tutorial, we recommend having a CUDA
compatible GPU with 6GB of memory or more. Each training iteration took about
one hour and a half on a standard desktop computer with an Intel Core i5 9600K
processor and an Nvidia RTX 2070 GPU.

!!! note
    To get optimal performances, it is also recommended to use
    `AlphaZero.jl` with Julia 1.4 (nightly), which includes a
    [critical feature](https://github.com/JuliaLang/julia/pull/33448)
    that enables `CuArrays` to force incremental GC collections.


In the following sections, we discuss some of those arguments in more details.

## Picking Hyperparameters

### Neural Network

Here, we use the same architecture
that is deployed in AlphaGo Zero, namely a two-headed convolutional resnet
with batch normalization. However, our network is
is smaller in size as it only features 7 blocks (instead of 20)
and 128 convolutional filters per layer (instead of 256), resulting in about
2.5M parameters (instead of 90M).

### Training Parameters

Here, we simulate 5000 games of
  self-play per iteration, using 400 MCTS iterations per move. For comparison,
  the original AlphaGo Zero plays 25,000 games of self-play per iteration,
  using 1600 MCTS iterations per move.

| Implementation | Games per iteration | Moves per Game | Sims per move | Inference cost |
|----------------|---------------------|----------------|---------------|----------------|
| AlphaGo Zero   |              25,000 |            200 |          1600 |            x40 |
| `AlphaZero.jl` |               5,000 |             30 |           400 |             x1 |
| Python impl    |                 100 |             30 |            25 |             x1 |

## Hyperparameters

Depending on your available computing power, you may want to adjust
some of these hyperparameters.
