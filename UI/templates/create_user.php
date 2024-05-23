<!-- create_user.php -->
<?php
session_start();
// Check if the user is logged in and is an admin
if (!isset($_SESSION['loggedin']) || $_SESSION['privilege'] != 'admin') {
    header('Location: index.php');
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Create New User</title>
</head>
<body>
    <h2>Create New User</h2>
    <form action="create_user_process.php" method="post">
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required><br>
        <label for="privilege">Privilege:</label><br>
        <select id="privilege" name="privilege" required>
            <option value="cook">Cook</option>
            <option value="admin">Admin</option>
        </select><br><br>
        <input type="submit" value="Create User">
    </form>
</body>
</html>
