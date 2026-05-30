<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'caed_zone';

    public function up(): void
    {
        Schema::create('membership_tiers', function (Blueprint $table) {
            $table->string('tier', 16)->primary();
            $table->decimal('min_spent', 12, 2)->default(0);
            $table->unsignedInteger('min_wins')->default(0);
            $table->decimal('fee_discount_pct', 5, 2)->default(0);
            $table->boolean('priority_queue')->default(false);
            $table->decimal('cashback_pct', 5, 2)->default(0);
            $table->timestamps();
        });

        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('channel', ['line', 'email', 'in_app']);
            $table->string('event', 40);
            $table->json('payload_json')->nullable();
            $table->boolean('is_read')->default(false);
            $table->timestamps();

            $table->index(['user_id', 'is_read']);
        });

        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('action', 60);
            $table->string('target_type', 40)->nullable();
            $table->unsignedBigInteger('target_id')->nullable();
            $table->string('ip', 45)->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->index(['target_type', 'target_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
        Schema::dropIfExists('notifications');
        Schema::dropIfExists('membership_tiers');
    }
};
