# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 1000, 1200

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (256*(1024**2)), (300*(1024**2))