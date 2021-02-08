from itertools import chain
import torch.nn as nn
import torch
import torch.nn.functional as F
from IPython import embed
import numpy as np


class Layer(nn.Module):
    """ U-Net Layer """

    def __init__(self, num_channels_in, num_channels_out, ndims, batch_norm=False):

        super(Layer, self).__init__()

        conv_op = nn.Conv2d if ndims == 2 else nn.Conv3d
        batch_nrom_op = nn.BatchNorm2d if ndims == 2 else nn.BatchNorm3d

        conv1 = conv_op(num_channels_in,  num_channels_out,
                        kernel_size=3, padding=1)
        conv2 = conv_op(num_channels_out, num_channels_out,
                        kernel_size=3, padding=1)

        bn1 = batch_nrom_op(num_channels_out)
        bn2 = batch_nrom_op(num_channels_out)
        self.unet_layer = nn.Sequential(
            conv1, bn1, nn.ReLU(), conv2, bn2, nn.ReLU())

    def forward(self, x):
        return self.unet_layer(x)


class SPHarmNet(nn.Module):
    """ The U-Net. """

    def __init__(self, config):

        super(SPHarmNet, self).__init__()
        self.config = config

        max_pool = nn.MaxPool3d(2) if config.ndims == 3 else nn.MaxPool2d(2)
        # ConvLayer = nn.Conv3d if config.ndims == 3 else nn.Conv2d
        # ConvTransposeLayer = nn.ConvTranspose3d if config.ndims == 3 else nn.ConvTranspose2d

        out_shape = np.array(config.patch_shape)
        '''  Down layers '''
        down_layers = [Layer(config.num_input_channels,
                             config.first_layer_channels, config.ndims)]
        for i in range(1, config.steps + 1):
            down_layers.append(max_pool)
            lyr = Layer(config.first_layer_channels * 2**(i - 1),
                        config.first_layer_channels * 2**i, config.ndims, config.batch_norm)
            down_layers.append(lyr)
            out_shape = out_shape//2

        feature_count = np.prod(out_shape) * config.first_layer_channels * 2**i

        fc_layers = [nn.Linear(feature_count, feature_count//8)]
        fc_layers.append(nn.Linear(feature_count//8, feature_count//64))
        fc_layers.append(nn.Linear(feature_count//64, feature_count//256))
        fc_layers.append(nn.Linear(feature_count//256,
                                   config.spharm_coefficient_count))

        # print('-->'+str(feature_count + feature_count//8 + feature_count//64 + feature_count//256 + config.spharm_coefficient_count)) #TODO

        # fc_layers.append(nn.Linear(feature_count, feature_count//4))  # TODO
        # fc_layers.append(nn.Linear(feature_count//4, feature_count//16))
        # fc_layers.append(nn.Linear(feature_count//16, feature_count//64))
        # fc_layers.append(nn.Linear(feature_count//64, feature_count//128))
        # fc_layers.append(nn.Linear(feature_count//128, feature_count//256))
        # fc_layers.append(nn.Linear(feature_count//256,
        #                            config.spharm_coefficient_count))

        self.conv_encoder = nn.Sequential(*down_layers)
        self.fc_layers = nn.Sequential(*fc_layers)

        # TODO remove
        # print(self.conv_encoder)
        # print(self.fc_layers)

    def forward(self, data):

        x = data['x'].cuda()

        latent = self.conv_encoder(x)

        _, C, D, H, W = latent.shape
        latent = latent.view(-1, C*D*H*W)

        return self.fc_layers(latent)

    def loss(self, data, epoch):

        pred = self.forward(data)

        MSE_Loss = nn.MSELoss()
        loss = MSE_Loss(pred, data['y_spharm_coeffs'].cuda())

        log = {"loss": loss.detach()}

        return loss, log
