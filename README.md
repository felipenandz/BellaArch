

> Follow the steps: 

---------------------------------------

# Before Start


#### The Arch is a CAShapeLayer and has to be added inside the viewcontroller's layer. In the init of BellaArch you need to pass the rect where it will born. after that you add the arch to the viewcontroller's layer keeping the reference it.


Inside the BellaArch layer there is a method called  [Execute]
Animate the layer to target calling  .execute(action: .startAnimation)

By Steps : 

> Import BellaArch inside the document as module 
> Create [BellaArch]  CAShape Layer
> Inside the init BellaArch you have to pass the rect where you want the layer to born. 
> keep the reference of the layer
> Call the methods by REFERENCE.execute(Action: )

---------------------------------------


# Methods to call Inside Execute


showLine          # (Presents the layer inside the View) 
removeLine       (Remove the layer from the View)
updateLocation (Updates the layer Location - I suggest to remove before Update)
startAnimation   (Animate layer until the path)


# Implemente the delegate inside the SuperView. It calls BellaArchDelegate

- Inside the delegate there is a method (updateNewLocation)
(this is where you will change the adress of the reference inside the SuperView to the new location) by changing it also asign the delegate to the new Layer )

