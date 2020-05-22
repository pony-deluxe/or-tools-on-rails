class VRPService
  attr_accessor :data, :manager, :routing, :distance_callback, :transit_callback_index, :dimension_name, :solution
  def initialize
    @data = {}
    data[:distance_matrix] = [[0, 2575, 2687, 5119, 3942, 3824, 3526, 2659, 4590, 3668, 5446, 1616, 7740, 9489, 2972, 1422, 3242, 2560, 3410, 4660], [2836, 0, 5066, 6693, 4387, 1791, 4423, 4340, 2129, 996, 4986, 2524, 5278, 9341, 5350, 3800, 4629, 4266, 4096, 2534], [2783, 4691, 0, 4411, 5233, 5130, 4561, 3530, 6707, 5785, 6323, 3884, 9857, 8353, 713, 1821, 4277, 3481, 4169, 6519], [4427, 6141, 3672, 0, 9014, 5873, 4099, 7028, 6675, 6507, 5861, 5675, 9741, 3572, 3597, 3818, 3815, 7445, 8219, 7969], [3946, 4332, 4944, 9394, 0, 5493, 7784, 2548, 5945, 4634, 7868, 3462, 9095, 13336, 5762, 5059, 7500, 1893, 930, 4235], [3936, 1116, 5651, 6294, 5002, 0, 4437, 5440, 1365, 443, 4112, 3624, 4515, 9354, 5935, 4385, 4642, 5054, 4711, 2421], [3098, 4316, 4480, 3753, 7685, 3201, 0, 6162, 3822, 3655, 1762, 4345, 9720, 5305, 4451, 3879, 594, 6087, 6419, 6640], [3052, 4239, 3512, 7508, 2783, 5488, 6948, 0, 6255, 5333, 7511, 3104, 9405, 11450, 3876, 4015, 7154, 702, 1719, 5142], [4522, 2258, 6237, 7576, 5958, 1142, 3823, 6027, 0, 1398, 4293, 4210, 3156, 9129, 6522, 4972, 4417, 5953, 5667, 3377], [4089, 913, 6822, 6448, 4643, 942, 3671, 5231, 1394, 0, 4141, 3777, 4544, 9508, 7107, 5557, 4796, 4695, 4352, 2062], [5501, 4890, 7053, 5479, 8560, 3929, 1727, 7006, 4551, 4383, 0, 5190, 7958, 6694, 6178, 5787, 2320, 6932, 7264, 6707], [1608, 2258, 4174, 6327, 3474, 3507, 4968, 2689, 4274, 3352, 5530, 0, 7424, 8445, 4686, 2869, 5173, 2615, 2947, 3514], [7654, 5389, 9369, 10611, 9170, 4274, 6858, 9158, 3137, 4530, 8186, 7342, 0, 13763, 9653, 8103, 7452, 9084, 8879, 5265], [6666, 8380, 8143, 3067, 11252, 8074, 5990, 11499, 11020, 9474, 6614, 7913, 13506, 0, 8068, 8289, 4861, 11916, 12690, 10208], [2862, 4664, 292, 4425, 5312, 5913, 4575, 3774, 6680, 5758, 6337, 3963, 9830, 8367, 0, 1836, 4291, 3559, 4248, 6754], [1383, 3541, 1905, 4125, 6413, 3979, 4235, 3583, 5556, 4634, 6155, 3074, 8706, 8067, 1876, 0, 3951, 3483, 4632, 5368], [2735, 4450, 4117, 3390, 7322, 5106, 2060, 5799, 5908, 5543, 3280, 3983, 11238, 4841, 4088, 3516, 0, 5725, 6057, 6277], [2463, 3653, 3345, 7887, 2226, 4902, 6362, 664, 5669, 4746, 6925, 2518, 8818, 11829, 3857, 3426, 6568, 0, 1162, 4586], [3726, 4377, 4427, 8464, 1127, 5626, 7086, 1863, 6102, 4791, 7649, 3242, 9251, 12406, 4832, 4507, 7292, 1376, 0, 4391], [4229, 2669, 6428, 8055, 4248, 2909, 6462, 4837, 3361, 2050, 6108, 3107, 5839, 10173, 6712, 5162, 6178, 4300, 3957, 0]]

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
