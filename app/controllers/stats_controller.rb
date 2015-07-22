class StatsController < ApplicationController
  def get_stats
    usw =  Usagewatch
    stats = {
        'cpu_usage' => usw.uw_cpuused,
        'ram_usage' => usw.uw_memused,
        'disk_usage' => usw.uw_diskused,
        'disk_available' => usw.uw_diskavailable,
        'disk_total' => usw.uw_totaldisk,
        'ram_total' => usw.uw_memtotal,
        'ram_used' => usw.uw_memactive
    }
    render json: stats
  end
end
