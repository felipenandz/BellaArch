

> Follow the steps: 

# Basically the Arch works with two View Frame. The first one is where the layer will born and the second View Frame is the Target 


View. Animate the layer to target calling  .execute(action: .startAnimation)


> Import BellaArch inside the document as package 
> Create [BellaArch]  CAShape Layer
> Inside the init BellaArch you have to pass the rect where you want the layer to born. 
> keep the reference of the layer
> Call the methods by REFERENCE.execute(Action: )

# Methods to call 

showLine          # (Presents the layer inside the View) 
removeLine       (Remove the layer from the View)
updateLocation (Updates the layer Location - I suggest to remove before Update)
startAnimation   (Animate layer until the path)


# Implemente the delegate inside the SuperView. It calls BellaArchDelegate

- Inside the delegate there is a method (updateNewLocation)
(this is where you will change the adress of the reference inside the SuperView to the new location) by changing it also asign the delegate to the new Layer )
