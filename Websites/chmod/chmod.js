// Function to update the numeric and symbolic permissions
function updatePermissions() {
  const ownerPermissions = calculatePermission('owner-read', 'owner-write', 'owner-execute');
  const groupPermissions = calculatePermission('group-read', 'group-write', 'group-execute');
  const publicPermissions = calculatePermission('public-read', 'public-write', 'public-execute');

  // Update Numeric Permissions
  const numericPermissions = `${ownerPermissions}${groupPermissions}${publicPermissions}`;
  document.getElementById('numeric-permissions').value = numericPermissions;

  // Update Symbolic Permissions
  const symbolicPermissions = `${getSymbolic(ownerPermissions)}${getSymbolic(groupPermissions)}${getSymbolic(publicPermissions)}`;
  document.getElementById('symbolic-permissions').value = symbolicPermissions;
}

// Function to calculate the numeric permission value for a given group (owner, group, public)
function calculatePermission(readId, writeId, executeId) {
  let permission = 0;
  if (document.getElementById(readId).checked) permission += 4;
  if (document.getElementById(writeId).checked) permission += 2;
  if (document.getElementById(executeId).checked) permission += 1;
  return permission;
}

// Function to convert numeric permissions to symbolic format
function getSymbolic(permissionValue) {
  const symbols = ['r', 'w', 'x'];
  let symbolic = '';
  for (let i = 0; i < 3; i++) {
      symbolic += (permissionValue & (4 >> i)) ? symbols[i] : '-';
  }
  return symbolic;
}
