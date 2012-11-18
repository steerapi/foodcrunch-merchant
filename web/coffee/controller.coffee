#Page
FoodCrunchMerchant  = ($scope)->
NearbyCustomers = ($scope)->
ManageDiscounts = ($scope)->
ExpectedDemandMerchant = ($scope)->
ManageAccounts = ($scope)->
ManagePayments = ($scope)->

Graph = ($scope)->
  dataHybrid = [
    label: "10:00"
    p: 50
  ,
    label: "10:15"
    p: 50
  ,
    label: "10:30"
    p: 50
  ,
    label: "10:45"
    p: 50
  ,
    label: "11:00"
    p: 50
  ,
    label: "11:15"
    p: 50
  ,
    label: "11:30"
    p: 50
  ,
    label: "11:45"
    p: 50
  ]
  atAtimeShow = 6
  atAtimeMove = 1
    
  $scope.init = ->
    # getHybrid (data)->
    $scope.all = dataHybrid
    $scope.current = 0
    data = $scope.all.slice $scope.current,$scope.current+atAtimeShow
    plot(data)
  processData = (data)->
    labels = _.pluck data, "label"
    discounts = _.pluck data, "p"
    ticks = []
    for label,i in labels
      ticks.push [i,label]
    data = []
    for discount,i in discounts
      data.push [i,discount]
    [data, ticks]
  plotGraph = null
  plot = (data)->
    [data,ticks] = processData data
    console.log data
    console.log ticks
    css_id = "#placeholder"
    data = [
      data: data
    ]
    options =
      grid:
        show: true
        clickable: true
      series:
        stack: 0
        bars:
          show: true
          barWidth: 1.0
          align: "center"
      xaxis:
        ticks: ticks

    plotGraph = $.plot $(css_id), data, options
    $(css_id).unbind()
    $(css_id).bind "plotclick", (event, pos, item) ->
      if (item)
        console.log "item"
        $scope.selectedData = dataHybrid[$scope.current + item.dataIndex]
  $scope.init()
  
  update = (newV)->
    data = $scope.all.slice $scope.current,$scope.current+atAtimeShow
    $("#placehoder").empty()
    plot data

  updateHor = (newV)->
    $scope.current = newV
    data = $scope.all.slice $scope.current,$scope.current+atAtimeShow
    $("#placehoder").empty()
    plot data
    ids = ["50a8b55807e58a812800331f","50a90568f5aee49f75000e38","1", "2", "3"]
    ids.forEach (id)->
      entity = new Kinvey.Entity({},"Schedule")
      console.log entity
      entity.load id,
        success: ->
          entity.set "p",p
          entity.save()
        error: ->
    # plotGraph = $.plot $("#placehoder"), data, options
    # plotGraph.setData [
    #   data:data
    # ]
    # plotGraph.getAxes().xaxis.ticks = ticks
    # plotGraph.draw()    
  $scope.dow = "Monday"
  $scope.increase = ->
    $scope.selectedData.p+=2
    update($scope.selectedData.p)
    
  $scope.decrease = ->
    $scope.selectedData.p-=2
    update($scope.selectedData.p)
  $scope.prev = ->
    newV = $scope.current-atAtimeMove
    if newV < 0
      return
    updateHor(newV)
  $scope.next = ->
    newV = $scope.current+atAtimeMove
    if newV+atAtimeShow > $scope.all.length
      return
    updateHor(newV)
    