<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('member', function (Blueprint $table) {
            $table->id();
            $table->string('display_name', 80);
            $table->string('email', 160)->unique();
            $table->string('phone', 20)->nullable();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password')->nullable();
            $table->enum('login_provider', ['email', 'line', 'google'])->default('email');
            $table->string('provider_uid', 120)->nullable();
            $table->string('avatar_url', 255)->nullable();
            $table->enum('membership_tier', ['bronze', 'silver', 'gold', 'platinum'])->default('bronze');
            $table->decimal('total_spent', 12, 2)->default(0);
            $table->unsignedInteger('auction_wins')->default(0);
            $table->enum('role', ['member', 'seller', 'admin'])->default('member');
            $table->enum('status', ['active', 'suspended'])->default('active');
            $table->rememberToken();
            $table->timestamps();

            $table->index(['provider_uid', 'login_provider']);
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('member');
    }
};
