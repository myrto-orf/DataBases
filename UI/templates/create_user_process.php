<!-- create_user_process.php -->
<?php
session_start();
// Check if the user is logged in and is an admin
if (!isset($_SESSION['loggedin']) || $_SESSION['privilege'] != 'admin') {
    header('Location: index.php');
    exit;
}

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

// Get the form data
$username = $_POST['username'];
$password = $_POST['password'];
$privilege = $_POST['privilege'];

// Hash the password
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO users (username, password, privilige) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $username, $hashed_password, $privilege);

// Execute the statement
if ($stmt->execute()) {
    echo "New user created successfully";
} else {
    echo "Error: " . $stmt->error;
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Redirect back to the create user form
header('Location: create_user.php?success=1');
exit;
?>
