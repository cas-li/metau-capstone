
// The example below shows you how a cloud code function looks like.

// Parse Server 3.x

var stringSimilarity = require('string-similarity');

Parse.Cloud.define("validatePassword", (request) => {
  return("Hello world!");
});

Parse.Cloud.beforeSave(Parse.User, async (request) => {
  var username = await request.object.get("username");
  console.log("name = ", username);
  request.object.set(
    "searchName",
    username.toLowerCase()
  );
});

Parse.Cloud.afterSave(Parse.User, async (request) => {
  const SearchItem = Parse.Object.extend("SearchItem");
  const searchItem = new SearchItem();
  var currentUser = request.object;
  var username = await request.object.get("username");

  searchItem.save({
    searchName: username.toLowerCase(),
    user: currentUser
  })
  .then((searchItem) => {
    // The object was saved successfully.
  }, (error) => {
    // The save failed.
    // error is a Parse.Error with an error code and message.
  });
});

Parse.Cloud.beforeSave("VentAudience", async (request) => {
  var vent = await request.object.get("vent");
  var user = await request.object.get("user");
  var group = await request.object.get("group");

  request.object.set(
    "ventId",
    vent.id
  );

  if (user != null) {
    request.object.set(
      "userId",
      user.id
    );
  }
  if (group != null) {
    request.object.set(
      "groupId",
      group.id
    );
  }
});

Parse.Cloud.beforeSave("Vent", async (request) => {
  var author = await request.object.get("author");

  request.object.set(
    "authorUserId",
    author.id
  );
});

Parse.Cloud.beforeSave("GroupDetails", async (request) => {
  var currentGroup = request.object;
  var groupName = await request.object.get("groupName");
  var author = await currentGroup.get("groupAuthor");

  request.object.set(
    "groupAuthorUserId",
    author.id
  );

  request.object.set(
    "searchName",
    groupName.toLowerCase()
  );

});

Parse.Cloud.afterSave("GroupDetails", async (request) => {
  const SearchItem = Parse.Object.extend("SearchItem");
  const searchItem = new SearchItem();
  var currentGroup = request.object;
  var groupName = await request.object.get("groupName");

  searchItem.save({
    searchName: groupName.toLowerCase(),
    group: currentGroup
  })
  .then((searchItem) => {
    // The object was saved successfully.
  }, (error) => {
    // The save failed.
    // error is a Parse.Error with an error code and message.
  });

});

Parse.Cloud.beforeSave("SearchItem", async (request) => {
  var group = await request.object.get("group");
  var user = await request.object.get("user");

  if (group !== undefined) {
    request.object.set(
      "groupId",
      group.id
    );
  }
  else if (user !== undefined) {
    request.object.set(
      "userId",
      user.id
    );
  }
  else {
    console.log("something bad happened");
  }

});

Parse.Cloud.beforeSave("GroupMembership", async (request) => {
  var group = await request.object.get("group");
  var user = await request.object.get("user");

  request.object.set(
    "groupId",
    group.id
  );

  request.object.set(
    "userId",
    user.id
  );

});

Parse.Cloud.define("existsFollow", async (request) => {
 const query = new Parse.Query("Follow");
 query.equalTo("followingUserId", request.params.followingUserId);
 query.equalTo("currentUserId", request.params.currentUserId);
 const results = await query.find();
 if (results.length > 0) {
   return true;
 }
 return false;
});

Parse.Cloud.define("fetchUserCellData", async (request) => {
  console.log("Hello World");
  var limit = request.params.limit;
  var currentUserId = request.params.currentUserId;
  let results = [];
  var userQuery = new Parse.Query("User");
  if (request.params.searchString !== undefined) {
    userQuery.contains("searchName", request.params.searchString.toLowerCase());
  }
  userQuery.limit(limit);
  const userResult = await userQuery.find();
  for (let i = 0; i < userResult.length; i++) {
    var user = userResult[i];
    var followQuery = new Parse.Query("Follow");
    followQuery.equalTo("followingUserId", user.id);
    followQuery.equalTo("currentUserId", currentUserId);
    const followResult = await followQuery.find();
    if (followResult.length > 0) {
      var modelDict = {"isFollowing": true,
                    "user": user};
      results.push(modelDict);
    }
    else {
      var modelDict = {"isFollowing": false,
                    "user": user};
      results.push(modelDict);
    }

  }
  return results;
});

async function compare(a, b, searchString) {
  var a_group = await a.get("group");
  var a_user = await a.get("user");
  var a_string;
  if (a_group !== undefined) {
    a_string = a_group.get("groupName");
  }
  else if (a_user !== undefined) {
    a_string = a_user.get("username");
  }
  else {
    return;
  }

  var b_group = await b.get("group");
  var b_user = await b.get("user");
  var b_string;
  if (b_group !== undefined) {
    b_string = b_group.get("groupName");
  }
  else if (a_user !== undefined) {
    b_string = b_user.get("username");
  }
  else {
    return;
  }

  return stringSimilarity.compareTwoStrings(b_string, searchString) - stringSimilarity.compareTwoStrings(a_string, searchString);
}

function sortWithSearchString(array, searchString) {
  return array.sort(function (a, b) {
    var a_group = a.get("group");
    var a_user = a.get("user");
    var a_string;
    if (a_group !== undefined) {
      a_string = a_group.get("groupName");
    }
    else if (a_user !== undefined) {
      a_string = a_user.get("username");
    }
    else {
      return;
    }

    var b_group = b.get("group");
    var b_user = b.get("user");
    var b_string;
    if (b_group !== undefined) {
      b_string = b_group.get("groupName");
    }
    else if (a_user !== undefined) {
      b_string = b_user.get("username");
    }
    else {
      return;
    }
    return stringSimilarity.compareTwoStrings(b_string, searchString) - stringSimilarity.compareTwoStrings(a_string, searchString);
});
}
Parse.Cloud.define("fetchUsersAndGroups", async (request) => {
  console.log("Hello World");
  var limit = request.params.limit;
  var currentUserId = request.params.currentUserId;
  let results = [];

  var searchItemQuery = new Parse.Query("SearchItem");
  if (request.params.searchString !== undefined) {
    searchItemQuery.contains("searchName", request.params.searchString.toLowerCase());
  }
  searchItemQuery.include(["group.groupAuthor"]);
  searchItemQuery.include(["group.groupName"]);
  searchItemQuery.include("user");
  searchItemQuery.include(["user.username"]);
  const searchItemResult = await searchItemQuery.find();

  if (request.params.searchString !== undefined) {
    var sortedItems = sortWithSearchString(searchItemResult, request.params.searchString.toLowerCase());
  }
  else {
    var sortedItems = searchItemResult;
  }

  for (let i = 0; i < sortedItems.length; i++) {
    var item = sortedItems[i];
    var group = await item.get("group");
    var user = await item.get("user");
    if (group !== undefined) {
      if (group.get("groupAuthor").id == currentUserId) {
        results.push(group);
      }
      continue;
    }
    if (user !== undefined) {
      var followQuery = new Parse.Query("Follow");
      followQuery.equalTo("followingUserId", user.id);
      followQuery.equalTo("currentUserId", currentUserId);
      const followResult = await followQuery.find();
      if (followResult.length > 0) {
        var modelDict = {"isFollowing": true,
                      "user": user};
        results.push(modelDict);
      }
      else {
        var modelDict = {"isFollowing": false,
                      "user": user};
        results.push(modelDict);
      }
    }

  }

  return results;
});

Parse.Cloud.define("postVent", async (request) => {
  const Vent = Parse.Object.extend("Vent");
  const vent = new Vent();
  const currentUserId = request.params.currentUserId;
  var ventAudiencesIds = request.params.ventAudiencesIds;
  var ventContent = request.params.ventContent;

  const userQuery = new Parse.Query("User");
  userQuery.equalTo("objectId", currentUserId);
  const user = await userQuery.first();

  if (user == undefined) {
    return;
  }

  vent.set("author", user);
  vent.set("ventContent", ventContent);
  vent.set("trackUri", request.params.selectedTrackUri);
  vent.set("startTimestamp", request.params.startTimestamp);
  vent.set("endTimestamp", request.params.endTimestamp);

  vent.save()
  .then((vent) => {
  }, (error) => {
    alert('Failed to create new object, with error code: ' + error.message);
    return;
  });

  var ventAudienceArray = [];
  for (var i = 0; i < ventAudiencesIds.length; i++) {
    let currentAudienceId = ventAudiencesIds[i];

    const VentAudience = Parse.Object.extend("VentAudience");
    const ventAudience = new VentAudience();

    const userQuery = new Parse.Query("User");
    userQuery.equalTo("objectId", currentAudienceId);
    const user = await userQuery.first();

    const groupQuery = new Parse.Query("GroupDetails");
    groupQuery.equalTo("objectId", currentAudienceId);
    const group = await groupQuery.first();

    ventAudience.set("vent", vent);

    if (user !== undefined) {
      ventAudience.set("user", user);
    }
    else if (group !== undefined) {
      ventAudience.set("group", group);
    }
    else {
      console.log("not a user or group");
      continue;
    }

    ventAudienceArray.push(ventAudience);
  }
  Parse.Object.saveAll(ventAudienceArray);

  return;
});

Parse.Cloud.define("createGroup", async (request) => {
  const Group = Parse.Object.extend("GroupDetails");
  const group = new Group();
  const authorId = request.params.authorId;
  var groupMembershipIds = request.params.groupMembershipIds;
  var groupName = request.params.groupName;

  const userQuery = new Parse.Query("User");
  userQuery.equalTo("objectId", authorId);
  const user = await userQuery.first();

  if (user == undefined) {
    return;
  }

  group.set("groupAuthor", user);
  group.set("groupName", groupName);

  group.save()
  .then((group) => {
  }, (error) => {
    alert('Failed to create new object, with error code: ' + error.message);
    return;
  });

  var groupMembershipArray = [];
  for (var i = 0; i < groupMembershipIds.length; i++) {
    let currentMembershipId = groupMembershipIds[i];

    const GroupMembership = Parse.Object.extend("GroupMembership");
    const groupMembership = new GroupMembership();

    const userQuery = new Parse.Query("User");
    userQuery.equalTo("objectId", currentMembershipId);
    const user = await userQuery.first();

    groupMembership.set("group", group);

    if (user !== undefined) {
      groupMembership.set("user", user);
    }
    else {
      console.log("not a user");
      continue;
    }

    groupMembershipArray.push(groupMembership);
  }
  Parse.Object.saveAll(groupMembershipArray);

  return;
});

Parse.Cloud.define("fetchPotentialAudienceUsers", async (request) => {
  var limit = request.params.limit;
  let results = [];
  var followQuery = new Parse.Query("Follow");
  followQuery.equalTo("followingUserId", request.params.currentUserId);
  followQuery.equalTo("approved", true);
  followQuery.limit(limit);
  followQuery.include("currentUser");
  const followResult = await followQuery.find();
  return followResult;
});

Parse.Cloud.define("fetchPotentialAudienceGroups", async (request) => {
  var limit = request.params.limit;
  let results = [];
  var groupQuery = new Parse.Query("GroupDetails");
  groupQuery.equalTo("groupAuthorUserId", request.params.groupAuthorUserId);
  groupQuery.limit(limit);
  groupQuery.include("currentUser");
  const groupResult = await groupQuery.find();
  return groupResult;
});

Parse.Cloud.define("fetchHomeTimeline", async (request) => {
  var limit = request.params.limit;
  var currentUserId = request.params.currentUserId;
  let results = [];

  //get users that currentUser is following
  var followQuery = new Parse.Query("Follow");
  followQuery.equalTo("currentUserId", currentUserId);
  followQuery.equalTo("approved", true);
  followQuery.include("followingUserId");
  const followResult = await followQuery.find();
  var followingUsersIds = followResult.map(a => a.get("followingUserId"));

  // get following's vents
  var ventsQuery = new Parse.Query("Vent");
  ventsQuery.containedIn("authorUserId", followingUsersIds);
  const rawVents = await ventsQuery.find();
  var rawVentsIds = rawVents.map(a => a.id);

  // get following's groups that currentUser is in
  var groupsQuery = new Parse.Query("GroupDetails");
  groupsQuery.containedIn("groupAuthorUserId", followingUsersIds);
  groupsQuery.include("objectId");
  const groups = await groupsQuery.find();
  var groupsArray = groups.map(a => a.id);
  groupsArray.push(undefined);

  let currentUserArray = [currentUserId];
  currentUserArray.push(undefined);

  // get vents
  var vaQuery = new Parse.Query("VentAudience");
  vaQuery.containedIn("ventId", rawVentsIds);
  vaQuery.containedIn("userId", currentUserArray);
  vaQuery.containedIn("groupId", groupsArray);
  vaQuery.include("vent");
  vaQuery.limit(limit);
  vaQuery.descending("createdAt");
  var vaResults = await vaQuery.find();
  var ventsArray = vaResults.map(a => a.get("vent"));

  // remove duplicate vents
  var filteredVentsArray = ventsArray.filter((v,i,a)=>a.findIndex(v2=>(v2.id===v.id))===i);

  return filteredVentsArray;
});

/* Parse Server 2.x
* Parse.Cloud.define("hello", function(request, response){
* 	response.success("Hello world!");
* });
*/

// To see it working, you only need to call it through SDK or REST API.
// Here is how you have to call it via REST API:

/** curl -X POST \
* -H "X-Parse-Application-Id: kniju7zULq2flcCwJ7PEG3U8bgQlxqFMBn2NEKPH" \
* -H "X-Parse-REST-API-Key: SgJDPTnyrRLmSUWkM7bIQ3BLwgdPDTH6qidYBBmN" \
* -H "Content-Type: application/json" \
* -d "{}" \
* https://parseapi.back4app.com/functions/hello
*/

// If you have set a function in another cloud code file, called "test.js" (for example)
// you need to refer it in your main.js, as you can see below:

/* require("./test.js"); */
