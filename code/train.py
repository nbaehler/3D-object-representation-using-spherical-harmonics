import logging
import torch

# from torch.utils.tensorboard import SummaryWriter
from utils.utils_common import DataModes

import numpy as np
import time
import wandb
from IPython import embed
import time

logger = logging.getLogger(__name__)


class Trainer(object):
    def training_step(self, data, epoch):
        # Get the minibatch

        self.optimizer.zero_grad()
        loss, log = self.net.loss(data, epoch)
        loss.backward()
        self.optimizer.step()
        # embed()

        return log

    def __init__(
        self,
        net,
        trainloader,
        optimizer,
        numb_of_itrs,
        eval_every,
        save_path,
        evaluator,
    ):

        self.net = net
        self.trainloader = trainloader
        self.optimizer = optimizer

        self.numb_of_itrs = numb_of_itrs
        self.eval_every = eval_every
        self.save_path = save_path

        self.evaluator = evaluator

    def train(self, start_iteration=1):

        print("Start training...")

        self.net = self.net.train()
        iteration = start_iteration
        print_every = 1

        for _ in range(10000000):  # loop over the dataset multiple times
            evaluated = False
            for data in self.trainloader:

                # training step
                loss = self.training_step(data, iteration)

            if iteration % print_every == 0:
                log_vals = {key: value / print_every for key, value in loss.items()}
                log_vals["iteration"] = iteration
                wandb.log(log_vals)

            if iteration % self.eval_every == 0:  # print every K epochs
                self.evaluator.evaluate(iteration)
                evaluated = True

            if iteration >= self.numb_of_itrs:
                if not evaluated:
                    self.evaluator.evaluate(iteration)
                break

            iteration = iteration + 1

        print("... end training!")
