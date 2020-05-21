class VRPService
  attr_accessor :data, :manager, :routing, :distance_callback, :transit_callback_index, :dimension_name, :solution
  def initialize
    @data = {}
    data[:distance_matrix] = [
      [0, 548, 776, 696, 582, 274, 502, 194, 308, 194, 536, 502, 388, 354, 468, 776, 662],
      [548, 0, 684, 308, 194, 502, 730, 354, 696, 742, 1084, 594, 480, 674, 1016, 868, 1210],
      [776, 684, 0, 992, 878, 502, 274, 810, 468, 742, 400, 1278, 1164, 1130, 788, 1552, 754],
      [696, 308, 992, 0, 114, 650, 878, 502, 844, 890, 1232, 514, 628, 822, 1164, 560, 1358],
      [582, 194, 878, 114, 0, 536, 764, 388, 730, 776, 1118, 400, 514, 708, 1050, 674, 1244],
      [274, 502, 502, 650, 536, 0, 228, 308, 194, 240, 582, 776, 662, 628, 514, 1050, 708],
      [502, 730, 274, 878, 764, 228, 0, 536, 194, 468, 354, 1004, 890, 856, 514, 1278, 480],
      [194, 354, 810, 502, 388, 308, 536, 0, 342, 388, 730, 468, 354, 320, 662, 742, 856],
      [308, 696, 468, 844, 730, 194, 194, 342, 0, 274, 388, 810, 696, 662, 320, 1084, 514],
      [194, 742, 742, 890, 776, 240, 468, 388, 274, 0, 342, 536, 422, 388, 274, 810, 468],
      [536, 1084, 400, 1232, 1118, 582, 354, 730, 388, 342, 0, 878, 764, 730, 388, 1152, 354],
      [502, 594, 1278, 514, 400, 776, 1004, 468, 810, 536, 878, 0, 114, 308, 650, 274, 844],
      [388, 480, 1164, 628, 514, 662, 890, 354, 696, 422, 764, 114, 0, 194, 536, 388, 730],
      [354, 674, 1130, 822, 708, 628, 856, 320, 662, 388, 730, 308, 194, 0, 342, 422, 536],
      [468, 1016, 788, 1164, 1050, 514, 514, 662, 320, 274, 388, 650, 536, 342, 0, 764, 194],
      [776, 868, 1552, 560, 674, 1050, 1278, 742, 1084, 810, 1152, 274, 388, 422, 764, 0, 798],
      [662, 1210, 754, 1358, 1244, 708, 480, 856, 514, 468, 354, 844, 730, 536, 194, 798, 0]
    ]
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
