class VRPService
  attr_accessor :data, :manager, :routing, :distance_callback, :transit_callback_index, :dimension_name, :solution
  def initialize
    @data = {}
    data[:distance_matrix] = [[0.0, 2574.6, 2687.4, 5119.2, 3941.9, 3823.6, 3526.1, 2659.3, 4590.4, 3668.2, 5446.4, 1615.8, 7740.2, 9488.8, 2971.8, 1421.8, 3242.4, 2559.8, 3409.6, 4659.5], [2835.8, 0.0, 5065.8, 6693.0, 4386.8, 1790.7, 4423.1, 4340.4, 2128.6, 995.6, 4985.7, 2524.0, 5278.4, 9340.6, 5350.2, 3800.2, 4628.8, 4266.1, 4095.8, 2533.5], [2782.9, 4691.3, 0.0, 4411.2, 5232.9, 5130.0, 4560.7, 3529.9, 6707.2, 5784.9, 6322.5, 3883.9, 9856.9, 8353.2, 712.5, 1821.3, 4277.0, 3480.9, 4169.1, 6519.2], [4427.3, 6141.4, 3671.7, 0.0, 9013.8, 5872.7, 4099.1, 7028.0, 6674.7, 6507.0, 5860.9, 5674.5, 9740.6, 3571.8, 3596.7, 3817.9, 3815.4, 7444.8, 8219.0, 7969.3], [3946.1, 4331.9, 4943.5, 9393.7, 0.0, 5493.3, 7784.0, 2548.1, 5944.9, 4634.3, 7868.3, 3461.5, 9094.6, 13335.7, 5761.7, 5059.1, 7500.3, 1893.3, 930.2, 4234.6], [3935.6, 1115.5, 5650.8, 6294.2, 5001.9, 0.0, 4436.8, 5440.2, 1364.9, 442.6, 4112.2, 3623.8, 4514.6, 9354.2, 5935.1, 4385.1, 4642.4, 5054.1, 4711.0, 2421.1], [3098.1, 4315.9, 4479.6, 3752.5, 7684.6, 3201.0, 0.0, 6161.7, 3822.3, 3654.6, 1761.8, 4345.3, 9720.1, 5305.3, 4451.1, 3878.6, 593.5, 6087.4, 6419.4, 6640.1], [3051.7, 4239.0, 3511.8, 7508.0, 2782.5, 5488.0, 6948.4, 0.0, 6254.9, 5332.6, 7511.0, 3104.1, 9404.6, 11450.0, 3876.0, 4014.5, 7154.0, 701.5, 1718.7, 5142.4], [4522.2, 2257.7, 6237.3, 7575.7, 5957.5, 1142.1, 3823.2, 6026.8, 0.0, 1398.2, 4293.4, 4210.4, 3155.6, 9128.5, 6521.7, 4971.7, 4416.7, 5952.5, 5666.6, 3376.7], [4089.2, 912.8, 6822.2, 6447.8, 4642.7, 942.4, 3671.1, 5231.3, 1394.0, 0.0, 4141.3, 3777.4, 4543.7, 9507.8, 7106.5, 5556.6, 4796.0, 4694.8, 4351.8, 2061.9], [5501.4, 4890.4, 7052.7, 5479.2, 8560.3, 3929.3, 1726.6, 7006.1, 4550.6, 4382.8, 0.0, 5189.7, 7958.3, 6694.1, 6177.7, 5787.1, 2320.1, 6931.7, 7263.7, 6707.3], [1607.8, 2258.1, 4174.2, 6326.6, 3474.2, 3507.1, 4967.5, 2689.1, 4274.0, 3351.7, 5530.1, 0.0, 7423.7, 8445.1, 4686.0, 2869.3, 5173.1, 2614.8, 2946.7, 3514.0], [7653.7, 5389.2, 9368.8, 10610.7, 9170.2, 4273.7, 6858.2, 9158.3, 3137.4, 4529.7, 8185.8, 7341.9, 0.0, 13763.1, 9653.2, 8103.2, 7451.7, 9084.0, 8879.3, 5264.6], [6665.8, 8380.0, 8142.6, 3066.8, 11252.3, 8073.7, 5990.4, 11498.9, 11020.3, 9473.6, 6614.2, 7913.0, 13505.5, 0.0, 8067.6, 8288.8, 4860.7, 11915.7, 12689.9, 10207.8], [2861.5, 4664.1, 292.2, 4425.4, 5311.5, 5913.2, 4574.8, 3774.1, 6680.0, 5757.8, 6336.7, 3962.5, 9829.7, 8367.4, 0.0, 1835.5, 4291.2, 3559.4, 4247.7, 6753.7], [1382.6, 3540.5, 1904.5, 4125.0, 6412.8, 3979.2, 4234.9, 3582.8, 5556.3, 4634.1, 6155.2, 3073.5, 8706.0, 8067.0, 1876.0, 0.0, 3951.3, 3483.3, 4631.9, 5368.3], [2735.3, 4449.5, 4116.9, 3389.8, 7321.8, 5106.2, 2059.9, 5799.0, 5908.2, 5543.1, 3280.0, 3982.6, 11238.3, 4840.8, 4088.4, 3515.9, 0.0, 5724.7, 6056.6, 6277.4], [2463.1, 3652.7, 3345.1, 7887.4, 2225.8, 4901.7, 6362.1, 664.2, 5668.5, 4746.3, 6924.6, 2517.8, 8818.3, 11829.4, 3856.9, 3425.9, 6567.7, 0.0, 1162.0, 4585.7], [3726.2, 4376.6, 4426.5, 8463.5, 1127.4, 5625.6, 7086.0, 1863.4, 6101.5, 4790.9, 7648.5, 3241.7, 9251.2, 12405.5, 4831.5, 4507.3, 7291.6, 1376.3, 0.0, 4391.2], [4228.8, 2668.8, 6427.5, 8054.6, 4248.0, 2909.4, 6461.5, 4836.6, 3360.9, 2050.3, 6108.2, 3107.2, 5838.6, 10173.1, 6711.8, 5161.9, 6177.9, 4300.1, 3957.0, 0.0]]

    data[:num_vehicles] = 2
    data[:depot] = 0

    # define the distance callback
    @manager = ORTools::RoutingIndexManager.new(data[:distance_matrix].length, data[:num_vehicles], data[:depot])
    @routing = ORTools::RoutingModel.new(manager)
    @distance_callback = lambda do |from_index, to_index|
      from_node = manager.index_to_node(from_index)
      to_node = manager.index_to_node(to_index)
      data[:distance_matrix][from_node][to_node]
    end
    @transit_callback_index = routing.register_transit_callback(distance_callback)
    routing.set_arc_cost_evaluator_of_all_vehicles(transit_callback_index)

    # add a distance dimension
    @dimension_name = "Distance"
    routing.add_dimension(transit_callback_index, 0, 3000, true, dimension_name)
    distance_dimension = routing.mutable_dimension(dimension_name)
    distance_dimension.global_span_cost_coefficient = 100

    # run the solver
    @solution = routing.solve(first_solution_strategy: :path_cheapest_arc)
  end


  # print the solution
  def print_solution
    max_route_distance = 0
    data[:num_vehicles].times do |vehicle_id|
      index = routing.start(vehicle_id)
      plan_output = String.new("Route for vehicle #{vehicle_id}:\n")
      route_distance = 0
      while !routing.end?(index)
        plan_output += " #{manager.index_to_node(index)} -> "
        previous_index = index
        index = solution.value(routing.next_var(index))
        route_distance += routing.arc_cost_for_vehicle(previous_index, index, vehicle_id)
      end
      plan_output += "#{manager.index_to_node(index)}\n"
      plan_output += "Distance of the route: #{route_distance}m\n\n"
      puts plan_output
      max_route_distance = [route_distance, max_route_distance].max
    end
    puts "Maximum of the route distances: #{max_route_distance}m"
  end
end
