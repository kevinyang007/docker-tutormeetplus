#!/bin/bash

service WowzaStreamingEngine start && service WowzaStreamingEngineManager start && tail -f /dev/null
