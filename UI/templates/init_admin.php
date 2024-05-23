<?php
// Hash the password
$admin_password = 'password'; // Replace with the actual password you want to use
$hashed_password = password_hash($admin_password, PASSWORD_DEFAULT);

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

// Insert the admin user
$admin_username = 'admin'; // Choose a username for the admin
$privilege = 'admin';
$stmt = $conn->prepare("INSERT INTO users (username, password, privilige) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $admin_username, $hashed_password, $privilege);

// Execute the statement
if ($stmt->execute()) {
    echo "Admin user created successfully";
} else {
    echo "Error: " . $stmt->error;
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
