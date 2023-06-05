#  Acknowledgements/Attributions file

__List of Third Party Libraries used__<br>

Name: FireBase<br>
Version: 10.10.0<br>
Purpose: To provide real-time data storage for task information <br>
Author: Google<br>
Licence Information: https://firebase.google.com/terms<br>

Name: Weather-API<br>
Version: n/a<br>
Purpose: To provide weather related information for the devices location<br>
Author: OPLAO FZCO<br>
Licence Information: License number 17552, https://www.weatherapi.com/terms.aspx<br>

Name: FSCalendar<br>
Version: 2.8.3<br>
Purpose: To provide an interactable calendar to visually track task completion<br>
Author: WenchaoD<br>
Licence Information: https://github.com/WenchaoD/FSCalendar/blob/master/LICENSE<br>


__Online sources references__<br>

I acknowledge the use of [1] ChatGPT (https://chat.openai.com/) [2] to fix errors and bugs in my program, as well as discover new ways of implementing features.<br>

On 5 July 2023 I submitted my project (https://git.infotech.monash.edu/fit3178-mcou0008/finalmobileapp) with the instruction to [3] “getting this error in my swift application "Unsupported type: FIT3178_FinalMobileApp.SubTask"”.<br>

[4] The output The error message you're encountering, "Unsupported type: FIT3178_FinalMobileApp.SubTask," suggests that there is an issue with the SubTask type in your Swift application. Without more context or code snippets, it's challenging to pinpoint the exact cause of the error. However, here are a few general steps you can take to troubleshoot the problem:

Verify the existence and accessibility of SubTask: Ensure that the SubTask type is defined and accessible in your codebase. Check that it is spelled correctly and that the appropriate import statements or module dependencies are in place.
Confirm type compatibility: Make sure that the SubTask type is compatible with the operation or context where it is being used. Check if the type conforms to any required protocols or inherits from the necessary superclass.
Check for circular dependencies: Circular dependencies between modules or classes can sometimes lead to obscure errors. Ensure that there are no circular dependencies involving the SubTask type.
Verify Swift version compatibility: If you recently updated your Swift version or related frameworks, ensure that the SubTask type is compatible with the current version. Some changes in language syntax or framework APIs can introduce compatibility issues.
Review the error context and stack trace: Examine the error message for additional details or a stack trace that may provide more insights into the issue. Look for any specific code lines or operations mentioned in the error message.
Search for similar issues: Search online forums, developer communities, or official documentation to see if other developers have encountered a similar issue with the Unsupported type error message. Their solutions or discussions may offer valuable guidance.
If you can provide more information or specific code snippets related to the error, I can assist you further in diagnosing and resolving the issue.

 This was then used to fix my error with the program.<br>


Prompt: "how to update an array in firebase using updateData"<br>

To update an array in Firebase Firestore using the updateData method, you can follow these steps:

Retrieve the document reference you want to update. You can do this by calling the document method on the Firestore collection and passing the document ID.
swift
Copy code
let documentRef = db.collection("your_collection").document("your_document_id")
Use the updateData method on the document reference to update the array field. Pass in a dictionary with the field you want to update and the new value. Make sure to specify the array field as a key and provide the updated array as the value.
swift
Copy code
documentRef.updateData([
    "your_array_field": newArray
]) { error in
    if let error = error {
        print("Error updating array field: \(error)")
    } else {
        print("Array field updated successfully!")
    }
}
Replace "your_array_field" with the actual name of the array field you want to update, and newArray with the updated array that you want to set.

It's important to note that when using updateData, it performs a partial update, meaning it will only modify the specified fields and leave the rest of the document unchanged. If the specified array field does not exist, it will be created with the provided value.

Additionally, be cautious when using updateData with arrays because it replaces the entire array with the new value. If you want to add or remove elements from the array without replacing it entirely, consider using the FieldValue.arrayUnion() and FieldValue.arrayRemove() methods, as explained in the previous response.

Remember to have the necessary Firebase Firestore dependencies and ensure that you have initialized Firebase in your project before using the updateData method. This was also used to gauge a better idea on how to update information using FireBase<br>

List of other prompts:
- "Missing argument for parameter 'from' in call where from is of Decoder type in swift"
- "how to create a segue to a view controller from a UIbutton programatically"
- "button isn't showing up when doing contentView.addSubview"
- "how can I make the table view controller cells draggable"
- "how can you update a document from a collection reference firebase"
- "got this error /Volumes/mcou0008/Documents/FIT3178/FIT3178-FinalMobileApp/FIT3178-FinalMobileApp/Base.lproj/Main.storyboard The subtaskTextField outlet from the EditTaskViewController to the UITextField is invalid. Outlets cannot be connected to repeating content."

For prompts that concern errors in the code, instructions given from the output was likely followed to resolve the issue. If a prompt concerned implementation and provided code, the output was modified to suit the existing code.<br>

