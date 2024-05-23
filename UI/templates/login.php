<?php
session_start();

// Database connection settings
$servername = "localhost";
$dbname = "user_auth";
$dbusername = "root"; // Use your MySQL username
$dbpassword = "password";     // Use your MySQL password

// Create connection
$conn = new mysqli($servername, $dbusername, $dbpassword, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the username and password from the POST request
$username = $_POST['username'];
$password = $_POST['password'];

// Prepare and bind
$stmt = $conn->prepare("SELECT id, username, password, privilige FROM users WHERE username = ?");
$stmt->bind_param("s", $username);

// Execute the statement
$stmt->execute();

// Store the result
$stmt->store_result();

// Bind the result variables
$stmt->bind_result($id, $db_username, $db_password_hash, $db_privilege);

// Check if a user was found and verify the password
if ($stmt->num_rows == 1) {
    $stmt->fetch();
    if (password_verify($password, $db_password_hash)) {
        // Password is correct, start a session
        $_SESSION['loggedin'] = true;
        $_SESSION['username'] = $db_username;
        $_SESSION['privilege'] = $db_privilege;
        header('Location: dashboard.php'); // Redirect to dashboard
        exit;
    } else {
        // Password is incorrect
        header('Location: index.php?error=invalid_credentials');
        exit;
    }
} else {
    // No user found with the provided username
    header('Location: index.php?error=invalid_credentials');
    exit;
}

?>
