namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class WestBlue : DbContext
    {
        static WestBlue()
        {
            //Database.SetInitializer<WestBlue>(null);
        }

        public WestBlue()
            : base("name=WestBlue")
        {
        }

        public WestBlue(bool needWriteAccess)
            : base(needWriteAccess ? "name=WestBlue" : "name=WestBlue")
        {
            
        }

        public virtual DbSet<course> courses { get; set; }
        public virtual DbSet<datamigration> datamigrations { get; set; }
        public virtual DbSet<leaderboard> leaderboards { get; set; }
        public virtual DbSet<leaderboarddata> leaderboarddatas { get; set; }
        public virtual DbSet<match> matches { get; set; }
        public virtual DbSet<pairing> pairings { get; set; }
        public virtual DbSet<player> players { get; set; }
        public virtual DbSet<playeryeardata> playeryeardatas { get; set; }
        public virtual DbSet<result> results { get; set; }
        public virtual DbSet<starttime> starttimes { get; set; }
        public virtual DbSet<team> teams { get; set; }
        public virtual DbSet<teammatchup> teammatchups { get; set; }
        public virtual DbSet<teamyeardata> teamyeardatas { get; set; }
        public virtual DbSet<user> users { get; set; }
        public virtual DbSet<week> weeks { get; set; }
        public virtual DbSet<year> years { get; set; }
        public virtual DbSet<note> notes { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<course>()
                .Property(e => e.name)
                .IsUnicode(false);

            modelBuilder.Entity<course>()
                .Property(e => e.street)
                .IsUnicode(false);

            modelBuilder.Entity<course>()
                .Property(e => e.state)
                .IsUnicode(false);

            modelBuilder.Entity<course>()
                .Property(e => e.zip)
                .IsUnicode(false);

            modelBuilder.Entity<course>()
                .HasMany(e => e.weeks)
                .WithRequired(e => e.course)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<datamigration>()
                .Property(e => e.notes)
                .IsUnicode(false);

            modelBuilder.Entity<note>()
                .Property(e => e.text)
                .IsUnicode(false);

            modelBuilder.Entity<leaderboard>()
                .Property(e => e.name)
                .IsUnicode(false);

            modelBuilder.Entity<leaderboard>()
                .Property(e => e.key)
                .IsUnicode(false);

            modelBuilder.Entity<leaderboard>()
                .HasMany(e => e.leaderboarddatas)
                .WithRequired(e => e.leaderboard)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<leaderboarddata>()
                .Property(e => e.detail)
                .IsUnicode(false);

            modelBuilder.Entity<leaderboarddata>()
                .Property(e => e.formattedValue)
                .IsUnicode(false);

            modelBuilder.Entity<match>()
                .HasMany(e => e.results)
                .WithRequired(e => e.match)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<match>()
                .HasMany(e => e.players)
                .WithMany(e => e.matches)
                .Map(m => m.ToTable("matchtoplayer").MapLeftKey("matchId").MapRightKey("playerId"));

            modelBuilder.Entity<pairing>()
                .Property(e => e.pairingText)
                .IsUnicode(false);

            modelBuilder.Entity<pairing>()
                .HasMany(e => e.weeks)
                .WithRequired(e => e.pairing)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<player>()
                .Property(e => e.name)
                .IsUnicode(false);

            modelBuilder.Entity<player>()
                .HasMany(e => e.playeryeardatas)
                .WithRequired(e => e.player)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<player>()
                .HasMany(e => e.results)
                .WithRequired(e => e.player)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<starttime>()
                .Property(e => e.time)
                .IsUnicode(false);

            modelBuilder.Entity<team>()
                .Property(e => e.teamName)
                .IsUnicode(false);

            modelBuilder.Entity<team>()
                .HasMany(e => e.playeryeardatas)
                .WithRequired(e => e.team)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<team>()
                .HasMany(e => e.results)
                .WithRequired(e => e.team)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<team>()
                .HasMany(e => e.teamyeardata)
                .WithRequired(e => e.team)
                .WillCascadeOnDelete(true);

	        modelBuilder.Entity<team>()
		        .HasMany(e => e.teammatchups)
		        .WithMany(e => e.teams)
		        .Map(m => m.ToTable("teammatchuptoteam").MapLeftKey("teamId").MapRightKey("teamMatchupId"));

            modelBuilder.Entity<teammatchup>()
                .Property(e => e.playoffType)
                .IsUnicode(false);

            modelBuilder.Entity<teammatchup>()
                .Property(e => e.matchupType)
                .IsUnicode(false);

            modelBuilder.Entity<teammatchup>()
                .HasMany(e => e.matches)
                .WithRequired(e => e.teammatchup)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<user>()
                .Property(e => e.username)
                .IsUnicode(false);

            modelBuilder.Entity<user>()
                .Property(e => e.passwordHash)
                .IsUnicode(false);

            modelBuilder.Entity<user>()
                .Property(e => e.salt)
                .IsUnicode(false);

            modelBuilder.Entity<user>()
                .Property(e => e.email)
                .IsUnicode(false);

            modelBuilder.Entity<user>()
                .Property(e => e.role)
                .IsUnicode(false);

            modelBuilder.Entity<week>()
                .HasMany(e => e.teammatchups)
                .WithRequired(e => e.week)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.datamigrations)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.leaderboarddatas)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.playeryeardatas)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.results)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.teamyeardata)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<year>()
                .HasMany(e => e.weeks)
                .WithRequired(e => e.year)
                .WillCascadeOnDelete(false);
        }
    }
}
